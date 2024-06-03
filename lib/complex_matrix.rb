# frozen_string_literal: true

require 'state_vector'

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

    build(width, height) do |r, c|
      rows[r][c]
    end
  end

  # Creates a column vector from the given coefficients.
  def self.column_vector(*coefs)
    build(1, coefs.length) do |r|
      coefs[r]
    end
  end

  # Builds a complex matrix with the specified width and height, using the
  # provided block to generate each element.
  def self.build(width, height, &block)
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

    new(width, height, buf)
  end

  def self.real_part_index(row, col, width)
    ((row * width) + col) * 2
  end

  private_class_method :real_part_index

  attr_reader :width, :height, :buffer

  def initialize(width, height, buffer)
    @width = width
    @height = height
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
    raise 'Cell out of range' if col >= @width

    ri = real_part_index(row, col)
    @buffer[ri] = value.real
    @buffer[ri + 1] = value.imag
  end

  def *(other)
    case other
    when Numeric
      # TODO: new_buffer ではなく ComplexMatrix.zer(@width, @height) で同じサイズのゼロ行列を作り、
      # 新しい行列の要素を each_with_index の中でセットする

      new_buffer = []

      other_r = Complex(other).real
      other_i = Complex(other).imag

      each do |v, index|
        new_real = (v.real * other_r) - (v.imag * other_i)
        new_imag = (v.real * other_i) + (v.imag * other_r)
        new_buffer[index] = new_real
        new_buffer[index + 1] = new_imag
      end

      ComplexMatrix.build(@width, @height) do |r, c|
        ri = real_part_index(r, c)
        ii = ri + 1
        Complex(new_buffer[ri], new_buffer[ii])
      end
    else
      raise 'Not yet supported'
    end
  end

  def each(&block)
    (0...@buffer.length).step(2) do |i|
      real = @buffer[i]
      imag = @buffer[i + 1]
      block.call Complex(real, imag), i
    end
  end

  def each_with_index(&block)
    (0...@buffer.length).step(2) do |i|
      real = @buffer[i]
      imag = @buffer[i + 1]
      element = Complex(real, imag)
      row = i % @width
      col = i / @width

      block.call element, row, col
    end
  end

  def tensor_product(other)
    w1 = @width
    h1 = @height
    w2 = other.width
    h2 = other.height
    w = w1 * w2
    h = h1 * h2
    new_buffer = []

    (0...h1).each do |r1|
      (0...h2).each do |r2|
        (0...w1).each do |c1|
          (0...w2).each do |c2|
            k1 = ((r1 * w1) + c1) * 2
            k2 = ((r2 * w2) + c2) * 2
            k3 = ((((r1 * h2) + r2) * w) + ((c1 * w2) + c2)) * 2
            cr1 = @buffer[k1]
            ci1 = @buffer[k1 + 1]
            cr2 = other.buffer[k2]
            ci2 = other.buffer[k2 + 1]
            cr3 = (cr1 * cr2) - (ci1 * ci2)
            ci3 = (cr1 * ci2) + (ci1 * cr2)

            new_buffer[k3] = cr3
            new_buffer[k3 + 1] = ci3
          end
        end
      end
    end

    ComplexMatrix.build(w, h) do |r, c|
      ri = ((r * w) + c) * 2
      ii = ri + 1
      Complex(new_buffer[ri], new_buffer[ii])
    end
  end

  def apply_controlled_gate(gate, target_bit, controls, anti_controls)
    control_mask = (controls + anti_controls).reduce(0) do |result, each|
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

    state_vector_length = @buffer.length / 2
    target_bit_shift = 1 << target_bit
    qubit_pair_offset = target_bit_shift * 2

    (0...state_vector_length).each do |ket|
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
