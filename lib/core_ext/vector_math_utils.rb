# frozen_string_literal: true

module CoreExt
  # Vector クラスに #tensor_product を追加
  module VectorMathUtils
    def sqrt
      map do |each|
        Math.sqrt(each)
      end
    end

    def tensor_product(other)
      Vector.elements(to_a.product(other.to_a).map { |a, b| a * b })
    end
  end
end
