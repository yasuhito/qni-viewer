#!/usr/bin/env ruby
# frozen_string_literal: true

require 'test_helper'
require 'unicode_fraction'

class UnicodeFractionAddTest < ActiveSupport::TestCase
  test '"1/2" + 1' do
    assert_equal 1.5, UnicodeFraction('1/2') + 1
  end

  test '"½" + 1' do
    assert_equal 1.5, UnicodeFraction('½') + 1
  end

  test '"√¼" + 1' do
    assert_equal 1.5, UnicodeFraction('√¼') + 1
  end

  test '0.5 + 1' do
    assert_equal 1.5, UnicodeFraction(0.5) + 1
  end

  test '1/√2 + 1' do
    assert_equal 1 + (1 / Math.sqrt(2)), UnicodeFraction(Math.sqrt(1 / 2.0)) + 1
  end
end
