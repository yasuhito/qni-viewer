# frozen_string_literal: true

require 'matrix'

# 状態ベクトルとその各種操作
class StateVector
  include Math
  extend Forwardable

  def_delegator :@vector, :size
  def_delegator :@vector, :[]
  def_delegator :@vector, :[]=
  def_delegator :@vector, :map

  # カスタム例外: 状態ベクトル初期化に使うビット文字列が不正
  class InvalidBitStringError < StandardError
    def initialize(bits)
      super("Invalid bit string: '#{bits}'")
    end
  end

  def initialize(bits)
    @vector = parse_bit_string(bits)
  end

  def to_wolfram
    items = @vector.flat_map { |each| "{#{Complex(each).to_h}}" }
    "{#{items.join(', ')}}"
  end

  private

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
