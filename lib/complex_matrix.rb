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

  def self.col(*coefs)
    build(1, coefs.length) do |r|
      coefs[r]
    end
  end

  def self.build(width, height, &block)
    buf = []

    0.upto(height - 1) do |r|
      0.upto(width - 1) do |c|
        k = ((r * width) + c) * 2 # real part index
        v = Complex(block.call(r, c))

        buf[k] = v.real
        buf[k + 1] = v.imag
      end
    end

    new(width, height, buf)
  end

  attr_reader :width, :height, :buffer

  def initialize(width, height, buffer)
    @width = width
    @height = height
    @buffer = buffer
  end

  def rows
    (0...@height).map do |row|
      (0...@width).map do |col|
        self[row, col]
      end
    end
  end

  def *(other)
    case other
    when Numeric
      new_buffer = []

      other_r = Complex(other).real
      other_i = Complex(other).imag

      each_cell do |real, imag, index|
        new_real = (real * other_r) - (imag * other_i)
        new_imag = (real * other_i) + (imag * other_r)
        new_buffer[index] = new_real
        new_buffer[index + 1] = new_imag
      end

      ComplexMatrix.new(@width, @height, new_buffer)
    else
      raise 'Not yet supported'
    end
  end

  def set(col, row, value)
    i = ((@width * row) + col) * 2
    @buffer[i] = value.real
    @buffer[i + 1] = value.imag
  end

  def [](row, col)
    raise 'Cell out of range' if row >= @height

    i = ((@width * row) + col) * 2
    Complex(@buffer[i], @buffer[i + 1])
  end

  # TODO: 上のメソッドに合わせて (または標準の Matrix クラスに合わせて) メソッド名を変更
  def each_cell(&block)
    (0...@buffer.length).step(2) do |i|
      real = @buffer[i]
      imag = @buffer[i + 1]
      block.call real, imag, i
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

    ComplexMatrix.new(w, h, new_buffer)
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
end
# rubocop:enable Metrics/ClassLength
