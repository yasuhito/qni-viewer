#!/usr/bin/env ruby
# frozen_string_literal: true

require 'test_helper'
require 'fraction'

class FractionTest < ActiveSupport::TestCase
  test '√½' do
    fraction = Fraction('√½')
    assert_equal '√½', fraction.to_s
  end

  test 'Matrix * √½' do
    matrix = Matrix[[1, 2], [3, 4]] * Fraction('√½')

    assert_in_delta 1 / Math.sqrt(2), matrix[0, 0]
    assert_in_delta 2 / Math.sqrt(2), matrix[0, 1]
    assert_in_delta 3 / Math.sqrt(2), matrix[1, 0]
    assert_in_delta 4 / Math.sqrt(2), matrix[1, 1]
  end
end
