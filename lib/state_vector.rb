# frozen_string_literal: true

require 'matrix'

class Vector
  def tensor_product(other)
    Vector.elements(to_a.product(other.to_a).map { |a, b| a * b })
  end
end

class StateVector
  attr_reader :matrix

  def initialize(bits)
    @bits = bits
    @kets = []

    @bits.chars.each do |each|
      raise "Invalid bit string: #{each}" unless each == '0'

      @kets << Vector[Complex(1), Complex(0)]
    end

    # @kets のすべての要素についてテンソル積を計算し変数 matrix に入れる
    @matrix = @kets.inject(&:tensor_product)
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
