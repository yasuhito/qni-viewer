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

      @kets << Vector[1, 0]
    end

    # @kets のすべての要素についてテンソル積を計算し変数 matrix に入れる
    @matrix = @kets.inject(&:tensor_product)
  end
end
