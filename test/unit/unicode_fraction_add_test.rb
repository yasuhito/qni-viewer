#!/usr/bin/env ruby
# frozen_string_literal: true

require 'test_helper'
require 'unicode_fraction'

class UnicodeFractionAddTest < ActiveSupport::TestCase
  test '1/2 + 1' do
    assert_equal 1.5, UnicodeFraction('1/2') + 1
  end

  test '½ + 1' do
    assert_equal 1.5, UnicodeFraction('½') + 1
  end

  test '√¼ + 1' do
    assert_equal 1.5, UnicodeFraction('√¼') + 1
  end
end
