# frozen_string_literal: true

require 'test_helper'

class ComplexMatrixTest < ActiveSupport::TestCase
  test 'ComplexMatrix[]' do
    m = ComplexMatrix[[1, 0], [-Complex::I, Complex(2, -3)]]

    assert_equal '{{1, 0}, {-i, 2-3i}}', m.to_s
  end

  test 'ComplexMatrix.column_vector' do
    m = ComplexMatrix.column_vector(2, 3, Complex(0, 5))

    assert_equal '{{2}, {3}, {5i}}', m.to_wolfram
  end

  test 'ComplexMatrix.build' do
    m = ComplexMatrix.build(2, 3)

    assert_equal '{{0, 0, 0}, {0, 0, 0}}', m.to_s
  end

  test 'ComplexMatrix.build with an element generator block' do
    m = ComplexMatrix.build(2, 3) { |r, c| r + (10 * c) }

    assert_equal '{{0, 10, 20}, {1, 11, 21}}', m.to_s
  end

  test '[2].to_s' do
    assert_equal '{{2}}', ComplexMatrix.column_vector(2).to_s
  end
end
