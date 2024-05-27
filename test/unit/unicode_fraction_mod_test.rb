# frozen_string_literal: true

require 'test_helper'
require 'unicode_fraction'

class UnicodeFractionModTest < ActiveSupport::TestCase
  test '"1/2" % 2' do
    assert_equal 0.5, UnicodeFraction('1/2') % 2
  end

  test '"½" % 2' do
    assert_equal 0.5, UnicodeFraction('½') % 2
  end

  test '"√¼" % 2' do
    assert_equal 0.5, UnicodeFraction('√¼') % 2
  end

  test '0.5 % 2' do
    assert_equal 0.5, UnicodeFraction(0.5) % 2
  end

  test '√½ % 2' do
    assert_equal Math.sqrt(1 / 2.0), UnicodeFraction(Math.sqrt(1 / 2.0)) % 2
  end
end
