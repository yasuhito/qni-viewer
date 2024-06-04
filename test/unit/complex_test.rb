# frozen_string_literal: true

require 'test_helper'

class ComplexTest < ActiveSupport::TestCase
  test '2-3i to wolfram alpha format' do
    assert_equal '2-3i', Complex(2, -3).to_wolfram
  end
end
