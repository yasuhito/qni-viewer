# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/vector'

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

  test '|00> to Wolfram language' do
    state_vector = StateVector.new('00')
    assert_equal '{{1}, {0}, {0}, {0}}', state_vector.to_wolfram
  end

  test '|01> to Wolfram language' do
    state_vector = StateVector.new('01')
    assert_equal '{{0}, {1}, {0}, {0}}', state_vector.to_wolfram
  end

  test '|0+> to Wolfram language' do
    state_vector = StateVector.new('0+')
    assert_equal '{{√½}, {√½}, {0}, {0}}', state_vector.to_wolfram
  end

  test '|0-> to Wolfram language' do
    state_vector = StateVector.new('0-')
    assert_equal '{{√½}, {-√½}, {0}, {0}}', state_vector.to_wolfram
  end

  test '|0i> to Wolfram language' do
    state_vector = StateVector.new('0i')
    assert_equal '{{√½}, {√½i}, {0}, {0}}', state_vector.to_wolfram
  end

  test '|0(-i)> to Wolfram language' do
    state_vector = StateVector.new('0(-i)')
    assert_equal '{{√½}, {-√½i}, {0}, {0}}', state_vector.to_wolfram
  end

  test '|> should raise an error' do
    assert_raises StateVector::InvalidBitStringError, match: "Invalid bit string: ''" do
      StateVector.new('')
    end
  end

  test '|(0> should raise an error' do
    assert_raises StateVector::InvalidBitStringError, match: "Invalid bit string: '(0'" do
      StateVector.new('(0')
    end
  end

  test '|(1> should raise an error' do
    assert_raises StateVector::InvalidBitStringError, match: "Invalid bit string: '(1'" do
      StateVector.new('(1')
    end
  end

  test '|(+> should raise an error' do
    assert_raises StateVector::InvalidBitStringError, match: "Invalid bit string: '(+'" do
      StateVector.new('(+')
    end
  end

  test '|(i> should raise an error' do
    assert_raises StateVector::InvalidBitStringError, match: "Invalid bit string: '(i'" do
      StateVector.new('(i')
    end
  end

  test '|((> should raise an error' do
    assert_raises StateVector::InvalidBitStringError, match: "Invalid bit string: '(('" do
      StateVector.new('((')
    end
  end

  test '|()> should raise an error' do
    assert_raises StateVector::InvalidBitStringError, match: "Invalid bit string: '()'" do
      StateVector.new('()')
    end
  end

  test '|(--> should raise an error' do
    assert_raises StateVector::InvalidBitStringError, match: "Invalid bit string: '(--'" do
      StateVector.new('(--')
    end
  end
end
