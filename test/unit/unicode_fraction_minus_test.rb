#!/usr/bin/env ruby
# frozen_string_literal: true

require 'test_helper'
require 'unicode_fraction'

class UnicodeFractionMinusTest < ActiveSupport::TestCase
  test '"1/2" - 1' do
    assert_equal(-0.5, UnicodeFraction('1/2') - 1)
  end

  test '"½" - 1' do
    assert_equal(-0.5, UnicodeFraction('½') - 1)
  end

  test '"√¼" - 1' do
    assert_equal(-0.5, UnicodeFraction('√¼') - 1)
  end

  test '0.5 - 1' do
    assert_equal(-0.5, UnicodeFraction(0.5) - 1)
  end

  test '√½ - 1' do
    assert_equal Math.sqrt(1 / 2.0) - 1, UnicodeFraction(Math.sqrt(1 / 2.0)) - 1
  end
end
