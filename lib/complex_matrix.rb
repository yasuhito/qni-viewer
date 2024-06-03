# frozen_string_literal: true

# Represents a matrix of complex numbers.
#
# The ComplexMatrix class provides methods for creating and manipulating
# matrices composed of complex numbers. It supports basic matrix operations such
# as addition, multiplication, and tensor product. It also provides methods for
# applying controlled gates and converting the matrix to Wolfram format.
#
# rubocop:disable Metrics/ClassLength
class ComplexMatrix
  # Creates a new ComplexMatrix object from the given rows.
  def self.[](*rows)
    width = rows[0].length
    height = rows.length

    build(height, width) do |r, c|
      rows[r][c]
    end
  end

  # Creates a column vector from the given coefficients.
  def self.column_vector(*coefs)
    build(coefs.length, 1) do |r|
      coefs[r]
    end
  end

  # Returns a new complex matrix with all elements initialized to zero.
  def self.zero(height, width)
    build(height, width) { 0 }
  end

  # Builds a complex matrix with the specified width and height, using the
  # provided block to generate each element.
  def self.build(height, width, &block)
    buf = []

    (0...height).each do |r|
      (0...width).each do |c|
        ri = real_part_index(r, c, width) # real part index
        ii = ri + 1 # imaginary part index
        v = Complex(block.call(r, c))

        buf[ri] = v.real
        buf[ii] = v.imag
      end
    end

    new(height, width, buf)
  end

  def self.real_part_index(row, col, width)
    ((row * width) + col) * 2
  end

  private_class_method :real_part_index

  attr_reader :height, :width

  def initialize(height, width, buffer)
    @height = height
    @width = width
    @buffer = buffer
  end

  private_class_method :new

  # Retrieves the value at the specified row and column in the complex matrix.
  def [](row, col)
    raise 'Cell out of range' if row >= @height
    raise 'Cell out of range' if col >= @width

    ri = real_part_index(row, col)
    Complex(@buffer[ri], @buffer[ri + 1])
  end

  # Sets the value of a cell in the complex matrix.
  def []=(row, col, value)
    raise 'Cell out of range' if row >= @height
    raise "Cell out of range: #{col} >= width (#{@width})" if col >= @width

    ri = real_part_index(row, col)
    @buffer[ri] = value.real
    @buffer[ri + 1] = value.imag
  end

  # Iterates over each element in the complex matrix.
  def each(&block)
    (0...@buffer.length).step(2) do |i|
      real = @buffer[i]
      imag = @buffer[i + 1]
      element = Complex(real, imag)

      block.call element
    end
  end

  # Iterates over each element in the complex matrix along with its row and
  # column index.
  def each_with_index(&block)
    (0...@buffer.length).step(2) do |i|
      real = @buffer[i]
      imag = @buffer[i + 1]
      element = Complex(real, imag)
      row = (i / 2) / @width
      col = (i / 2) % @width

      block.call element, row, col
    end
  end

  # Multiplies the complex matrix by a scalar or another complex matrix.
  #
  # TODO: Implement support for multiplying by another complex matrix.
  def *(other)
    case other
    when Numeric
      new_m = ComplexMatrix.zero(@height, @width)

      other_r = Complex(other).real
      other_i = Complex(other).imag

      each_with_index do |v, row, col|
        new_real = (v.real * other_r) - (v.imag * other_i)
        new_imag = (v.real * other_i) + (v.imag * other_r)
        new_m[row, col] = Complex(new_real, new_imag)
      end

      new_m
    else
      raise 'Not yet supported'
    end
  end

  # Performs the tensor product of the current matrix with another matrix.
  def tensor_product(other)
    new_m = ComplexMatrix.zero(@height * other.height, @width * other.width)

    (0...@height).each do |r1|
      (0...other.height).each do |r2|
        (0...@width).each do |c1|
          (0...other.width).each do |c2|
            k1 = ((r1 * @width) + c1) * 2
            cr1 = @buffer[k1]
            ci1 = @buffer[k1 + 1]
            cr2 = other[r2, c2].real
            ci2 = other[r2, c2].imag
            cr3 = (cr1 * cr2) - (ci1 * ci2)
            ci3 = (cr1 * ci2) + (ci1 * cr2)

            new_m[(r1 * other.height) + r2, (c1 * other.width) + c2] = Complex(cr3, ci3)
          end
        end
      end
    end

    new_m
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def apply_controlled_gate(gate, target_bit, controls, anti_controls)
    raise 'Not a column vector' if @width != 1
    raise 'Not a 2x2 matrix' if gate.height != 2 || gate.width != 2
    raise 'Target bit out of range' if 2 << target_bit > @height

    control_mask = (controls + anti_controls).reduce(0) do |result, each|
      raise 'Target bit cannot be a control' if each == target_bit

      result | (1 << each)
    end
    desired_value_mask = controls.reduce(0) do |result, each|
      result | (1 << each)
    end

    # | a b |
    # | c d |
    ar = gate[0, 0].real
    ai = gate[0, 0].imag
    br = gate[0, 1].real
    bi = gate[0, 1].imag
    cr = gate[1, 0].real
    ci = gate[1, 0].imag
    dr = gate[1, 1].real
    di = gate[1, 1].imag

    target_bit_shift = 1 << target_bit
    qubit_pair_offset = target_bit_shift * 2

    (0...@height).each do |ket|
      qubit_val = (ket & target_bit_shift) != 0
      next if qubit_val

      is_controlled = ((control_mask & ket) ^ desired_value_mask) != 0
      next if is_controlled

      i = ket * 2
      j = i + qubit_pair_offset

      xr = @buffer[i]
      xi = @buffer[i + 1]
      yr = @buffer[j]
      yi = @buffer[j + 1]

      @buffer[i] = (xr * ar) - (xi * ai) + (yr * br) - (yi * bi)
      @buffer[i + 1] = (xr * ai) + (xi * ar) + (yr * bi) + (yi * br)
      @buffer[j] = (xr * cr) - (xi * ci) + (yr * dr) - (yi * di)
      @buffer[j + 1] = (xr * ci) + (xi * cr) + (yr * di) + (yi * dr)
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def to_wolfram
    data = rows.map do |row|
      row.map(&:to_wolfram).join(', ')
    end.join('}, {')

    "{{#{data}}}"
  end

  private

  def rows
    (0...@height).map do |row|
      (0...@width).map do |col|
        self[row, col]
      end
    end
  end

  def real_part_index(row, col, width = @width)
    self.class.__send__ :real_part_index, row, col, width
  end
end
# rubocop:enable Metrics/ClassLength
