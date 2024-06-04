# frozen_string_literal: true

require 'test_helper'

class ComplexMatrixTest < ActiveSupport::TestCase
  test '[2].to_s' do
    assert_equal '{{2}}', ComplexMatrix.column_vector(2).to_s
  end

  test '[[1, 0], [-i, 2-3i]].to_s' do
    assert_equal '{{1, 0}, {-i, 2-3i}}', ComplexMatrix[[1, 0], [-Complex::I, Complex(2, -3)]].to_s
  end

  test '[[1, 0], [0, 1]].to_s' do
    assert_equal '{{1, 0}, {0, 1}}', ComplexMatrix[[1, 0], [0, 1]].to_s
  end

  test 'build' do
    m = ComplexMatrix.build(2, 3) { |r, c| r + (10 * c) }
    assert_equal '{{0, 10, 20}, {1, 11, 21}}', m.to_s
  end
end
