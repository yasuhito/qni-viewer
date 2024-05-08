# frozen_string_literal: true

module CoreExt
  # Vector クラスに #tensor_product を追加
  module VectorTensorProduct
    def tensor_product(other)
      Vector.elements(to_a.product(other.to_a).map { |a, b| a * b })
    end
  end
end
