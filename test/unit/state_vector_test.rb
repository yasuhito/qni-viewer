# frozen_string_literal: true

require 'test_helper'

class StateVectorTest < ActiveSupport::TestCase
  test '|0> to Wolfram language' do
    state_vector = StateVector.new('0')
    assert_equal '{{1}, {0}}', state_vector.to_wolfram
  end

  test '|1> to Wolfram language' do
    state_vector = StateVector.new('1')
    assert_equal '{{0}, {1}}', state_vector.to_wolfram
  end

  test '|+> to Wolfram language' do
    state_vector = StateVector.new('+')
    assert_equal '{{√½}, {√½}}', state_vector.to_wolfram
  end

  test '|-> to Wolfram language' do
    state_vector = StateVector.new('-')
    assert_equal '{{√½}, {-√½}}', state_vector.to_wolfram
  end

  test '|i> to Wolfram language' do
    state_vector = StateVector.new('i')
    assert_equal '{{√½}, {√½i}}', state_vector.to_wolfram
  end

  test '|-i> to Wolfram language' do
    state_vector = StateVector.new('(-i)')
    assert_equal '{{√½}, {-√½i}}', state_vector.to_wolfram
  end
end
