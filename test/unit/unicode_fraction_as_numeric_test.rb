#!/usr/bin/env ruby
# frozen_string_literal: true

require 'test_helper'
require 'unicode_fraction'

# UnicodeFraction が Numeric としてそのまま計算できることのテスト
class UnicodeFractionAsNumericTest < ActiveSupport::TestCase
  test 'Matrix * ½' do
    matrix = Matrix[[1, 2], [3, 4]] * UnicodeFraction('½')

    assert_equal 1 / 2.0, matrix[0, 0]
    assert_equal 2 / 2.0, matrix[0, 1]
    assert_equal 3 / 2.0, matrix[1, 0]
    assert_equal 4 / 2.0, matrix[1, 1]
  end

  test 'Matrix * √½' do
    matrix = Matrix[[1, 2], [3, 4]] * UnicodeFraction('√½')

    assert_in_delta 1 / Math.sqrt(2), matrix[0, 0]
    assert_in_delta 2 / Math.sqrt(2), matrix[0, 1]
    assert_in_delta 3 / Math.sqrt(2), matrix[1, 0]
    assert_in_delta 4 / Math.sqrt(2), matrix[1, 1]
  end
end
