# frozen_string_literal: true

require 'matrix'

# 状態ベクトルとその各種操作
class StateVector
  # 状態ベクトルを保持する行列
  class Matrix
    def self.col(*coefs)
      generate(1, coefs.length) do |r|
        coefs[r]
      end
    end

    # TODO: build に名前変更
    def self.generate(width, height, &block)
      buf = []

      0.upto(height - 1) do |r|
        0.upto(width - 1) do |c|
          k = ((r * width) + c) * 2 # real part index
          v = block.call(r, c)

          if v.is_a?(Complex)
            buf[k] = v.real
            buf[k + 1] = v.imag
          elsif v.is_a?(Numeric)
            buf[k] = v
            buf[k + 1] = 0
          else
            raise 'わかんないのが来た'
          end
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
          cell(col, row)
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

        Matrix.new(@width, @height, new_buffer)
      else
        raise 'Not yet supported'
      end
    end

    # TODO: メソッド名を標準の Matrix クラスと合わせる
    def cell(col, row)
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

              # k1 = (r1 * w1 + c1) * 2
              # k2 = ((r2 * w2) + c2) * 2
              # k3 = ((((r1 * h2) + r2) * w) + ((c1 * w2) + c2)) * 2
              # cr1 = @buffer[k1]
              # ci1 = @buffer[k1 + 1]
              # cr2 = other.buffer[k2]
              # ci2 = other.buffer[k2 + 1]
              # cr3 = (cr1 * cr2) - (ci1 * ci2)
              # ci3 = (cr1 * ci2) + (ci1 * cr2)
              new_buffer[k3] = cr3
              new_buffer[k3 + 1] = ci3
            end
          end
        end
      end

      Matrix.new(w, h, new_buffer)
      # tensorProduct(other: Matrix): Matrix {
      #   const w1 = this.width
      #   const h1 = this.height
      #   const w2 = other.width
      #   const h2 = other.height
      #   const w = w1 * w2
      #   const h = h1 * h2
      #   const newBuffer = new Float64Array(w * h * 2)
      #   for (let r1 = 0; r1 < h1; r1++) {
      #     for (let r2 = 0; r2 < h2; r2++) {
      #       for (let c1 = 0; c1 < w1; c1++) {
      #         for (let c2 = 0; c2 < w2; c2++) {
      #           const k1 = (r1 * w1 + c1) * 2
      #           const k2 = (r2 * w2 + c2) * 2
      #           const k3 = ((r1 * h2 + r2) * w + (c1 * w2 + c2)) * 2
      #           const cr1 = this.buffer[k1]
      #           const ci1 = this.buffer[k1 + 1]
      #           const cr2 = other.buffer[k2]
      #           const ci2 = other.buffer[k2 + 1]
      #           const cr3 = cr1 * cr2 - ci1 * ci2
      #           const ci3 = cr1 * ci2 + ci1 * cr2
      #           newBuffer[k3] = cr3
      #           newBuffer[k3 + 1] = ci3
      #         }
      #       }
      #     }
      #   }
      #   return new Matrix(w, h, newBuffer)
      # }
    end

    def to_wolfram
      data = rows.map do |row|
        row.map(&:to_wolfram).join(', ')
      end.join('}, {')

      "{{#{data}}}"
    end
  end

  include Math
  extend Forwardable

  # def_delegator :@vector, :size
  # def_delegator :@vector, :[]
  # def_delegator :@vector, :[]=
  # def_delegator :@vector, :map

  # カスタム例外: 状態ベクトル初期化に使うビット文字列が不正
  class InvalidBitStringError < StandardError
    def initialize(bits)
      super("Invalid bit string: '#{bits}'")
    end
  end

  def initialize(bits)
    @matrix = bit_string_to_matrix(bits)
  end

  def size
    @matrix.buffer.length / 2
  end

  # TODO: Complex を返すように修正
  def [](index)
    @matrix.buffer[index]
  end

  def []=(index, value)
    @matrix.buffer[index] = value
  end

  def amplifier(bit)
    Complex(@matrix.buffer[bit * 2], @matrix.buffer[(bit * 2) + 1])
  end

  def map(&block)
    result = []
    @matrix.each_cell do |real, imag, index|
      result_index = index * 0.5
      result[result_index] = block.call(real, imag)
    end
    result
  end

  def qubit_count
    Math.log2(size).to_i
  end

  def to_wolfram
    @matrix.to_wolfram
    # items = @vector.flat_map { |each| "{#{Complex(each).to_wolfram}}" }
    # "{#{items.join(', ')}}"
  end

  private

  def bit_string_to_matrix(bit_string)
    kets = []
    in_paren = false
    in_paren_token = nil

    bit_string.chars.each do |each|
      case each
      when '0' # |0>
        raise InvalidBitStringError, bit_string if in_paren

        kets << Matrix.col(1, 0)
      when '1' # |1>
        raise InvalidBitStringError, bit_string if in_paren

        kets << Matrix.col(0, 1)
      when '+' # |+>
        raise InvalidBitStringError, bit_string if in_paren

        # FIXME: Math.sqrt(0.5) を UnicodeFraction('√½') にする
        kets << (Matrix.col(1, 1) * Math.sqrt(0.5))
      when '-' # |->
        if in_paren
          raise InvalidBitStringError, bit_string unless in_paren_token == ''

          in_paren_token = '-'
        else # |->
          kets << (Matrix.col(1, -1) * Math.sqrt(0.5))
          # TODO: Matrix#[] を定義して、配列から作れるようにしたほうが @buffer を隠蔽できていいかも
          # kets << Vector[sqrt(0.5), -sqrt(0.5)]
        end
      when 'i'
        if in_paren
          raise InvalidBitStringError, bit_string unless in_paren_token == '-'

          in_paren_token = '-i'
        else # |i>
          kets << Matrix.col(Math.sqrt(0.5), Complex(0, Math.sqrt(0.5)))
          # kets << Vector[sqrt(0.5), Complex(0, sqrt(0.5))]
        end
      when '('
        raise InvalidBitStringError, bit_string if in_paren

        in_paren = true
        in_paren_token = ''
      when ')'
        raise InvalidBitStringError, bit_string unless in_paren_token == '-i'

        # |-i>
        kets << Matrix.col(Math.sqrt(0.5), Complex(0, -Math.sqrt(0.5)))
        # kets << Vector[sqrt(0.5), Complex(0, -sqrt(0.5))]
        in_paren = false
        in_paren_token = ''
      else
        raise InvalidBitStringError, bits
      end
    end

    raise InvalidBitStringError, bit_string if kets.empty?

    kets.inject(&:tensor_product)
  end

  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  def parse_bit_string(bits)
    kets = []
    in_paren = false
    in_paren_token = ''

    bits.chars.each do |each| # rubocop:disable Metrics/BlockLength
      case each
      when '0' # |0>
        raise InvalidBitStringError, bits if in_paren

        kets << Vector[1, 0]
      when '1' # |1>
        raise InvalidBitStringError, bits if in_paren

        kets << Vector[0, 1]
      when '+' # |+>
        raise InvalidBitStringError, bits if in_paren

        kets << Vector[0.5, 0.5].sqrt
        # kets << sqrt(Vector[0.5, 0.5])
      when '-'
        if in_paren
          raise InvalidBitStringError, bits unless in_paren_token == ''

          in_paren_token = '-'
        else # |->
          kets << Vector[sqrt(0.5), -sqrt(0.5)]
        end
      when 'i'
        if in_paren
          raise InvalidBitStringError, bits unless in_paren_token == '-'

          in_paren_token = '-i'
        else # |i>
          kets << Vector[sqrt(0.5), Complex(0, sqrt(0.5))]
        end
      when '('
        raise InvalidBitStringError, bits if in_paren

        in_paren = true
        in_paren_token = ''
      when ')'
        raise InvalidBitStringError, bits unless in_paren_token == '-i'

        # |-i>
        kets << Vector[sqrt(0.5), Complex(0, -sqrt(0.5))]
        in_paren = false
        in_paren_token = ''
      else
        raise InvalidBitStringError, bits
      end
    end

    raise InvalidBitStringError, bits if kets.empty?

    kets.inject(&:tensor_product)
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
end
