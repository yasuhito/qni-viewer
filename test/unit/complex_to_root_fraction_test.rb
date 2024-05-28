# frozen_string_literal: true

require 'test_helper'

# 複素数 (Complex) を '√' 付きの Unicode 分数文字列に変換
class ComplexToRootFractionTest < ActiveSupport::TestCase
  test 'Complex(Math.sqrt(0.5)) → √½' do
    assert_equal '√½', Complex(Math.sqrt(1.0 / 2)).to_wolfram
  end

  test 'Complex(0, Math.sqrt(0.5)) → √½i' do
    assert_equal '√½i', Complex(0, Math.sqrt(0.5)).to_wolfram
  end

  test 'Math.sqrt(3/4) → √¾' do
    assert_equal '√¾', Math.sqrt(Complex(3.0 / 4)).to_wolfram
  end

  test 'Math.sqrt(1/3) → √⅓' do
    assert_equal '√⅓', Math.sqrt(Complex(1.0 / 3)).to_wolfram
  end

  test 'Math.sqrt(2/3) → √⅔' do
    assert_equal '√⅔', Math.sqrt(Complex(2.0 / 3)).to_wolfram
  end

  test 'Math.sqrt(1/5) → √⅕' do
    assert_equal '√⅕', Math.sqrt(Complex(1.0 / 5)).to_wolfram
  end

  test 'Math.sqrt(2/5) → √⅖' do
    assert_equal '√⅖', Math.sqrt(Complex(2.0 / 5)).to_wolfram
  end

  test 'Math.sqrt(3/5) → √⅗' do
    assert_equal '√⅗', Math.sqrt(Complex(3.0 / 5)).to_wolfram
  end

  test 'Math.sqrt(4/5) → √⅘' do
    assert_equal '√⅘', Math.sqrt(Complex(4.0 / 5)).to_wolfram
  end

  test 'Math.sqrt(1/6) → √⅙' do
    assert_equal '√⅙', Math.sqrt(Complex(1.0 / 6)).to_wolfram
  end

  test 'Math.sqrt(5/6) → √⅚' do
    assert_equal '√⅚', Math.sqrt(Complex(5.0 / 6)).to_wolfram
  end

  test 'Math.sqrt(1/7) → √⅐' do
    assert_equal '√⅐', Math.sqrt(Complex(1.0 / 7)).to_wolfram
  end

  test 'Math.sqrt(1/8) → √⅛' do
    assert_equal '√⅛', Math.sqrt(Complex(1.0 / 8)).to_wolfram
  end

  test 'Math.sqrt(3/8) → √⅜' do
    assert_equal '√⅜', Math.sqrt(Complex(3.0 / 8)).to_wolfram
  end

  test 'Math.sqrt(5/8) → √⅝' do
    assert_equal '√⅝', Math.sqrt(Complex(5.0 / 8)).to_wolfram
  end

  test 'Math.sqrt(7/8) → √⅞' do
    assert_equal '√⅞', Math.sqrt(Complex(7.0 / 8)).to_wolfram
  end

  test 'Math.sqrt(1/10) → √⅒' do
    assert_equal '√⅒', Math.sqrt(Complex(1.0 / 10)).to_wolfram
  end
end
