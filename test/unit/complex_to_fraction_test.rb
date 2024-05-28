# frozen_string_literal: true

require 'test_helper'

# 複素数 (Complex) を Unicode 分数文字列に変換
class ComplexToFractionTest < ActiveSupport::TestCase
  test '1/2 → ½' do
    assert_equal '½', Complex(1.0 / 2).to_wolfram
  end

  test '1/4 → ¼' do
    assert_equal '¼', Complex(1.0 / 4).to_wolfram
  end

  test '3/4 → ¾' do
    assert_equal '¾', Complex(3.0 / 4).to_wolfram
  end

  test '1/3 → ⅓' do
    assert_equal '⅓', Complex(1.0 / 3).to_wolfram
  end

  test '2/3 → ⅔' do
    assert_equal '⅔', Complex(2.0 / 3).to_wolfram
  end

  test '1/5 → ⅕' do
    assert_equal '⅕', Complex(1.0 / 5).to_wolfram
  end

  test '2/5 → ⅖' do
    assert_equal '⅖', Complex(2.0 / 5).to_wolfram
  end

  test '3/5 → ⅗' do
    assert_equal '⅗', Complex(3.0 / 5).to_wolfram
  end

  test '4/5 → ⅘' do
    assert_equal '⅘', Complex(4.0 / 5).to_wolfram
  end

  test '1/6 → ⅙' do
    assert_equal '⅙', Complex(1.0 / 6).to_wolfram
  end

  test '5/6 → ⅚' do
    assert_equal '⅚', Complex(5.0 / 6).to_wolfram
  end

  test '1/7 → ⅐' do
    assert_equal '⅐', Complex(1.0 / 7).to_wolfram
  end

  test '1/8 → ⅛' do
    assert_equal '⅛', Complex(1.0 / 8).to_wolfram
  end

  test '3/8 → ⅜' do
    assert_equal '⅜', Complex(3.0 / 8).to_wolfram
  end

  test '5/8 → ⅝' do
    assert_equal '⅝', Complex(5.0 / 8).to_wolfram
  end

  test '7/8 → ⅞' do
    assert_equal '⅞', Complex(7.0 / 8).to_wolfram
  end

  test '1/9 → ⅑' do
    assert_equal '⅑', Complex(1.0 / 9).to_wolfram
  end

  test '1/10 → ⅒' do
    assert_equal '⅒', Complex(1.0 / 10).to_wolfram
  end
end
