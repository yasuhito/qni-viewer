# frozen_string_literal: true

require 'matrix'
require 'vector'

# 状態ベクトルとその各種操作
class StateVector
  extend Forwardable

  def_delegator :@vector, :size
  def_delegator :@vector, :[]
  def_delegator :@vector, :[]=
  def_delegator :@vector, :map

  def initialize(bits)
    @vector = parse_bits_string(bits)
  end

  def to_wolfram
    items = @vector.flat_map { |each| "{#{Complex(each).to_h}}" }
    "{#{items.join(', ')}}"
  end

  private

  # rubocop:disable Metrics/PerceivedComplexity
  def parse_bits_string(bits)
    kets = []
    in_paren = false
    in_paren_token = ''

    bits.chars.each do |each|
      case each
      when '0' # |0>
        kets << Vector[1, 0]
      when '1' # |1>
        kets << Vector[0, 1]
      when '+' # |+>
        kets << sqrt(Vector[0.5, 0.5])
      when '-'
        if in_paren
          in_paren_token += '-'
        else # |->
          kets << Vector[sqrt(0.5), -sqrt(0.5)]
        end
      when 'i'
        if in_paren
          in_paren_token += 'i'
        else # |i>
          kets << Vector[sqrt(0.5), Complex(0, sqrt(0.5))]
        end
      when '('
        in_paren = true
        in_paren_token = ''
      when ')'
        raise unless in_paren_token == '-i'

        # |-i>
        kets << Vector[sqrt(0.5), Complex(0, -sqrt(0.5))]
        in_paren = false
      else
        raise "Invalid bit string: #{each}"
      end
    end

    kets.inject(&:tensor_product)
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def sqrt(value)
    if value.is_a?(Numeric)
      Math.sqrt(value)
    else
      value.map do |each|
        Math.sqrt(each)
      end
    end
  end
end
