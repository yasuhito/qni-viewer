# frozen_string_literal: true

require 'test_helper'

# 状態ベクトルクラス (StateVector) のテスト
class StateVectorTest
  # 状態ベクトルの初期化テスト (1 量子ビット)
  class InitializationTest < ActiveSupport::TestCase
    test '|0>' do
      state_vector = StateVector.new('0')
      assert_equal '{{1}, {0}}', state_vector.to_wolfram
    end

    test '|1>' do
      state_vector = StateVector.new('1')
      assert_equal '{{0}, {1}}', state_vector.to_wolfram
    end

    test '|+>' do
      state_vector = StateVector.new('+')
      assert_equal '{{√½}, {√½}}', state_vector.to_wolfram
    end

    test '|->' do
      state_vector = StateVector.new('-')
      assert_equal '{{√½}, {-√½}}', state_vector.to_wolfram
    end

    test '|i>' do
      state_vector = StateVector.new('i')
      assert_equal '{{√½}, {√½i}}', state_vector.to_wolfram
    end

    test '|-i>' do
      state_vector = StateVector.new('(-i)')
      assert_equal '{{√½}, {-√½i}}', state_vector.to_wolfram
    end
  end

  # 状態ベクトルの初期化テスト (2 量子ビット)
  class InitializationWith2QubitsTest < ActiveSupport::TestCase
    test '|00>' do
      state_vector = StateVector.new('00')
      assert_equal '{{1}, {0}, {0}, {0}}', state_vector.to_wolfram
    end

    test '|01>' do
      state_vector = StateVector.new('01')
      assert_equal '{{0}, {1}, {0}, {0}}', state_vector.to_wolfram
    end

    test '|0+>' do
      state_vector = StateVector.new('0+')
      assert_equal '{{√½}, {√½}, {0}, {0}}', state_vector.to_wolfram
    end

    test '|0->' do
      state_vector = StateVector.new('0-')
      assert_equal '{{√½}, {-√½}, {0}, {0}}', state_vector.to_wolfram
    end

    test '|0i>' do
      state_vector = StateVector.new('0i')
      assert_equal '{{√½}, {√½i}, {0}, {0}}', state_vector.to_wolfram
    end

    test '|0(-i)>' do
      state_vector = StateVector.new('0(-i)')
      assert_equal '{{√½}, {-√½i}, {0}, {0}}', state_vector.to_wolfram
    end
  end

  # 状態ベクトルの初期化エラーテスト
  class InvalidBitStringErrorTest < ActiveSupport::TestCase
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
end
