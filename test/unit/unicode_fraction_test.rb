#!/usr/bin/env ruby
# frozen_string_literal: true

require 'test_helper'
require 'unicode_fraction'

class UnicodeFractionTest < ActiveSupport::TestCase
  test '½' do
    fraction = UnicodeFraction('½')
    assert_equal '½', fraction.to_s
  end

  test '√½' do
    fraction = UnicodeFraction('√½')
    assert_equal '√½', fraction.to_s
  end

  class FindWithCloseValueTest < ActiveSupport::TestCase
    test '½' do
      fraction = UnicodeFraction.find_with_close_value(1.0 / 2)
      assert_equal '½', fraction.to_s
    end
  end

  # TODO: Numeric との比較テストも追加 (assert_equal 0, UnicodeFraction.from_number(0))
  class FromNumberTest < ActiveSupport::TestCase
    test 'from 0' do
      fraction = UnicodeFraction.from_number(0)
      assert_equal '0', fraction.to_s
    end

    test 'from 1' do
      fraction = UnicodeFraction.from_number(1)
      assert_nil fraction
    end

    test 'from 1/2' do
      fraction = UnicodeFraction.from_number(1.0 / 2)
      assert_equal '½', fraction.to_s
    end

    test 'from 1/4' do
      fraction = UnicodeFraction.from_number(1.0 / 4)
      assert_equal '¼', fraction.to_s
    end

    test 'from 3/4' do
      fraction = UnicodeFraction.from_number(3.0 / 4)
      assert_equal '¾', fraction.to_s
    end

    test 'from 1/3' do
      fraction = UnicodeFraction.from_number(1.0 / 3)
      assert_equal '⅓', fraction.to_s
    end

    test 'from 2/3' do
      fraction = UnicodeFraction.from_number(2.0 / 3)
      assert_equal '⅔', fraction.to_s
    end

    test 'from 1/5' do
      fraction = UnicodeFraction.from_number(1.0 / 5)
      assert_equal '⅕', fraction.to_s
    end

    test 'from 2/5' do
      fraction = UnicodeFraction.from_number(2.0 / 5)
      assert_equal '⅖', fraction.to_s
    end

    test 'from 3/5' do
      fraction = UnicodeFraction.from_number(3.0 / 5)
      assert_equal '⅗', fraction.to_s
    end

    test 'from 4/5' do
      fraction = UnicodeFraction.from_number(4.0 / 5)
      assert_equal '⅘', fraction.to_s
    end

    test 'from 1/6' do
      fraction = UnicodeFraction.from_number(1.0 / 6)
      assert_equal '⅙', fraction.to_s
    end

    test 'from 5/6' do
      fraction = UnicodeFraction.from_number(5.0 / 6)
      assert_equal '⅚', fraction.to_s
    end

    test 'from 1/7' do
      fraction = UnicodeFraction.from_number(1.0 / 7)
      assert_equal '⅐', fraction.to_s
    end

    test 'from 1/8' do
      fraction = UnicodeFraction.from_number(1.0 / 8)
      assert_equal '⅛', fraction.to_s
    end

    test 'from 3/8' do
      fraction = UnicodeFraction.from_number(3.0 / 8)
      assert_equal '⅜', fraction.to_s
    end

    test 'from 5/8' do
      fraction = UnicodeFraction.from_number(5.0 / 8)
      assert_equal '⅝', fraction.to_s
    end

    test 'from 7/8' do
      fraction = UnicodeFraction.from_number(7.0 / 8)
      assert_equal '⅞', fraction.to_s
    end

    test 'from 1/9' do
      fraction = UnicodeFraction.from_number(1.0 / 9)
      assert_equal '⅑', fraction.to_s
    end

    test 'from 1/10' do
      fraction = UnicodeFraction.from_number(1.0 / 10)
      assert_equal '⅒', fraction.to_s
    end
  end

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
