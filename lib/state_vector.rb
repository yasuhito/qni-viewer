# frozen_string_literal: true

require 'forwardable'
require 'complex_matrix'

# 状態ベクトルとその各種操作
# rubocop:disable Metrics/ClassLength
class StateVector
  include Math
  extend Forwardable

  attr_reader :matrix

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

  def amplifier(index)
    @matrix[index, 0]
  end

  def set_amplifier(index, value)
    matrix.set(0, index, value)
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
    Math.log2(@matrix.buffer.length / 2).to_i
  end

  def to_wolfram
    @matrix.to_wolfram
  end

  def apply_controlled_gate(gate, target_bit, controls = [], anti_controls = [])
    @matrix.apply_controlled_gate(gate, target_bit, controls, anti_controls)
  end

  private

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  def bit_string_to_matrix(bit_string)
    kets = []
    in_paren = false
    in_paren_token = nil

    # rubocop:disable Metrics/BlockLength
    bit_string.chars.each do |each|
      case each
      when '0' # |0>
        raise InvalidBitStringError, bit_string if in_paren

        kets << ComplexMatrix.col(1, 0)
      when '1' # |1>
        raise InvalidBitStringError, bit_string if in_paren

        kets << ComplexMatrix.col(0, 1)
      when '+' # |+>
        raise InvalidBitStringError, bit_string if in_paren

        # FIXME: Math.sqrt(0.5) を UnicodeFraction('√½') にする
        kets << (ComplexMatrix.col(1, 1) * Math.sqrt(0.5))
      when '-' # |->
        if in_paren
          raise InvalidBitStringError, bit_string unless in_paren_token == ''

          in_paren_token = '-'
        else # |->
          kets << (ComplexMatrix.col(1, -1) * Math.sqrt(0.5))
          # TODO: ComplexMatrix#[] を定義して、配列から作れるようにしたほうが @buffer を隠蔽できていいかも
          # kets << Vector[sqrt(0.5), -sqrt(0.5)]
        end
      when 'i'
        if in_paren
          raise InvalidBitStringError, bit_string unless in_paren_token == '-'

          in_paren_token = '-i'
        else # |i>
          kets << ComplexMatrix.col(Math.sqrt(0.5), Complex(0, Math.sqrt(0.5)))
          # kets << Vector[sqrt(0.5), Complex(0, sqrt(0.5))]
        end
      when '('
        raise InvalidBitStringError, bit_string if in_paren

        in_paren = true
        in_paren_token = ''
      when ')'
        raise InvalidBitStringError, bit_string unless in_paren_token == '-i'

        # |-i>
        kets << ComplexMatrix.col(Math.sqrt(0.5), Complex(0, -Math.sqrt(0.5)))
        # kets << Vector[sqrt(0.5), Complex(0, -sqrt(0.5))]
        in_paren = false
        in_paren_token = ''
      else
        raise InvalidBitStringError, bits
      end
    end
    # rubocop:enable Metrics/BlockLength

    raise InvalidBitStringError, bit_string if kets.empty?

    kets.inject(&:tensor_product)
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

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
# rubocop:enable Metrics/ClassLength
