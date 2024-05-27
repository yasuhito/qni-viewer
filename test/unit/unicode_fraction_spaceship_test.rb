# frozen_string_literal: true

require 'test_helper'
require 'unicode_fraction'

class UnicodeFractionSpaceshipTest < ActiveSupport::TestCase
  test '"1/2" <=> 1' do
    assert_equal(-1, UnicodeFraction('1/2') <=> 1)
  end

  test '"1/2" <=> 0.5' do
    assert_equal 0, UnicodeFraction('1/2') <=> 0.5
  end

  test '"1/2" <=> 0' do
    assert_equal 1, UnicodeFraction('1/2') <=> 0
  end

  test '"½" <=> 1' do
    assert_equal(-1, UnicodeFraction('½') <=> 1)
  end

  test '"½" <=> 0.5' do
    assert_equal 0, UnicodeFraction('½') <=> 0.5
  end

  test '"½" <=> 0' do
    assert_equal 1, UnicodeFraction('½') <=> 0
  end

  test '"√¼" <=> 1' do
    assert_equal(-1, UnicodeFraction('√¼') <=> 1)
  end

  test '"√¼" <=> 0.5' do
    assert_equal 0, UnicodeFraction('√¼') <=> 0.5
  end

  test '"√¼" <=> 0' do
    assert_equal 1, UnicodeFraction('√¼') <=> 0
  end

  test '0.5 <=> 1' do
    assert_equal(-1, UnicodeFraction(0.5) <=> 1)
  end

  test '0.5 <=> 0.5' do
    assert_equal 0, UnicodeFraction(0.5) <=> 0.5
  end

  test '0.5 <=> 0' do
    assert_equal 1, UnicodeFraction(0.5) <=> 0
  end

  test '√½ <=> 1' do
    assert_equal(-1, UnicodeFraction(Math.sqrt(1 / 2.0)) <=> 1)
  end

  test '√½ <=> √½' do
    assert_equal 0, UnicodeFraction(Math.sqrt(1 / 2.0)) <=> Math.sqrt(1 / 2.0)
  end

  test '√½ <=> 0' do
    assert_equal 1, UnicodeFraction(Math.sqrt(1 / 2.0)) <=> 0
  end
end
