#!/usr/bin/env ruby
# frozen_string_literal: true

require 'test_helper'
require 'fraction'

class FractionTest < ActiveSupport::TestCase
  test '½' do
    fraction = Fraction('½')
    assert_equal '½', fraction.to_s
  end

  test '√½' do
    fraction = Fraction('√½')
    assert_equal '√½', fraction.to_s
  end

  # TODO: Numeric との比較テストも追加 (assert_equal 0, Fraction.from_number(0))
  class FromNumberTest < ActiveSupport::TestCase
    test 'from 0' do
      fraction = Fraction.from_number(0)
      assert_equal '0', fraction.to_s
    end

    test 'from 1/2' do
      fraction = Fraction.from_number(1.0 / 2)
      assert_equal '½', fraction.to_s
    end

    test 'from 1/4' do
      fraction = Fraction.from_number(1.0 / 4)
      assert_equal '¼', fraction.to_s
    end

    test 'from 3/4' do
      fraction = Fraction.from_number(3.0 / 4)
      assert_equal '¾', fraction.to_s
    end

    test 'from 1/3' do
      fraction = Fraction.from_number(1.0 / 3)
      assert_equal '⅓', fraction.to_s
    end

    test 'from 2/3' do
      fraction = Fraction.from_number(2.0 / 3)
      assert_equal '⅔', fraction.to_s
    end

    test 'from 1/5' do
      fraction = Fraction.from_number(1.0 / 5)
      assert_equal '⅕', fraction.to_s
    end
  end

  test 'Matrix * ½' do
    matrix = Matrix[[1, 2], [3, 4]] * Fraction('½')

    assert_equal 1 / 2.0, matrix[0, 0]
    assert_equal 2 / 2.0, matrix[0, 1]
    assert_equal 3 / 2.0, matrix[1, 0]
    assert_equal 4 / 2.0, matrix[1, 1]
  end

  test 'Matrix * √½' do
    matrix = Matrix[[1, 2], [3, 4]] * Fraction('√½')

    assert_in_delta 1 / Math.sqrt(2), matrix[0, 0]
    assert_in_delta 2 / Math.sqrt(2), matrix[0, 1]
    assert_in_delta 3 / Math.sqrt(2), matrix[1, 0]
    assert_in_delta 4 / Math.sqrt(2), matrix[1, 1]
  end
end
