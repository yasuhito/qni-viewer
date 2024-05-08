# frozen_string_literal: true

require 'matrix'

# Vector クラスに #tensor_product メソッドを追加
# TODO: core_ext に移動
class Vector
  def tensor_product(other)
    Vector.elements(to_a.product(other.to_a).map { |a, b| a * b })
  end
end

# 状態ベクトルのあれこれ
class StateVector
  attr_reader :matrix

  def initialize(bits)
    @bits = bits
    @kets = []
    paren = false
    paren_token = ''

    @bits.chars.each do |each|
      case each
      when '0'
        @kets << Vector[Complex(1), Complex(0)]
      when '1'
        @kets << Vector[Complex(0), Complex(1)]
      when '+'
        # TODO: Math.sqrt(Vector[0.5, 0.5]) みたいに書けないか調べる
        @kets << Vector[Complex(Math.sqrt(0.5)), Complex(Math.sqrt(0.5))]
      when '-'
        if paren
          paren_token += '-'
        else
          @kets << Vector[Complex(Math.sqrt(0.5)), -Complex(Math.sqrt(0.5))]
        end
      when 'i'
        if paren
          paren_token += 'i'
        else
          @kets << Vector[Complex(Math.sqrt(0.5)), Complex(0, Math.sqrt(0.5))]
        end
      when '('
        paren = true
        paren_token = ''
      when ')'
        raise unless paren_token == '-i'

        @kets << Vector[Complex(Math.sqrt(0.5)), Complex(0, -Math.sqrt(0.5))]
        paren = false
      else
        raise "Invalid bit string: #{each}"
      end
    end

    # @kets のすべての要素についてテンソル積を計算し変数 matrix に入れる
    @matrix = @kets.inject(&:tensor_product)
  end

  def to_wolfram
    items = @matrix.flat_map { |each| "{#{each.to_h}}" }
    "{#{items.join(', ')}}"
  end

  # TODO: 移譲
  def [](index)
    @matrix[index]
  end

  # TODO: 移譲
  def []=(index, complex)
    @matrix[index] = complex
  end

  # TODO: 移譲
  def size
    @matrix.size
  end
end
