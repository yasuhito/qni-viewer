# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/complex'
require_relative '../../lib/vector'

class CircuitsControllerTest
  class GateTest < ActionDispatch::IntegrationTest
    def amplitudes
      JSON.parse(@response.body).fetch('state_vector').map do |each|
        Complex(each['real'], each['imag'])
      end
    end

    def measured_bits
      JSON.parse(@response.body).fetch('measured_bits')
    end
  end

  class HGateTest < GateTest
    test <<~TEST do
         ┌───┐
      q: ┤ H ├
         └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["H"]] }' }, as: :json

      assert_equal 2, amplitudes.length
      assert_equal '√½', amplitudes[0].to_h
      assert_equal '√½', amplitudes[1].to_h
    end

    test <<~TEST do
      q_0: ─────
           ┌───┐
      q_1: ┤ H ├
           └───┘
      end
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [[1, "H"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal '√½', amplitudes[0].to_h
      assert_equal 0, amplitudes[1]
      assert_equal '√½', amplitudes[2].to_h
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ H ├
           ├───┤
      q_1: ┤ H ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["H", "H"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal '½', amplitudes[0].to_h
      assert_equal '½', amplitudes[1].to_h
      assert_equal '½', amplitudes[2].to_h
      assert_equal '½', amplitudes[3].to_h
    end
  end

  class XGateTest < GateTest
    test <<~TEST do
         ┌───┐
      q: ┤ X ├
         └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["X"]] }' }, as: :json

      assert_equal 2, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 1, amplitudes[1]
    end

    test <<~TEST do
      q_0: ─────
           ┌───┐
      q_1: ┤ X ├
           └───┘
      end
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [[1, "X"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 1, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ X ├
           ├───┤
      q_1: ┤ X ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["X", "X"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 1, amplitudes[3]
    end
  end

  class YGateTest < GateTest
    test <<~TEST do
         ┌───┐
      q: ┤ Y ├
         └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["Y"]] }' }, as: :json

      assert_equal 2, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 'i', amplitudes[1].to_h
    end

    test <<~TEST do
      q_0: ─────
           ┌───┐
      q_1: ┤ Y ├
           └───┘
      end
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [[1, "Y"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 'i', amplitudes[2].to_h
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ Y ├
           ├───┤
      q_1: ┤ Y ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["Y", "Y"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal(-1, amplitudes[3])
    end
  end

  class ZGateTest < GateTest
    test <<~TEST do
         ┌───┐
      q: ┤ Z ├
         └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["Z"]] }' }, as: :json

      assert_equal 2, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
    end

    test <<~TEST do
      q_0: ─────
           ┌───┐
      q_1: ┤ Z ├
           └───┘
      end
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [[1, "Z"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ Z ├
           ├───┤
      q_1: ┤ Z ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["Z", "Z"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end
  end

  class CnotGateTest < GateTest
    test 'Cnot (X が発火しない)' do
      get circuit_path, params: { circuit_json: '{ "cols": [["•", "X"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test 'Cnot (X が発火)' do
      get circuit_path, params: { circuit_json: '{ "cols": [["X"], ["•", "X"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 1, amplitudes[3]
    end
  end

  class AntiCnotGateTest < GateTest
    test 'AntiCnot (X が発火)' do
      get circuit_path, params: { circuit_json: '{ "cols": [["◦", "X"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 1, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test 'AntiCnot (X が発火しない)' do
      get circuit_path, params: { circuit_json: '{ "cols": [["X"], ["◦", "X"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 1, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end
  end

  class Write0GateTest < GateTest
    test <<~TEST do
         ┌───┐
      q: ┤|0>├
         └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["|0>"]] }' }, as: :json

      assert_equal 2, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
    end

    test <<~TEST do
      q_0: ─────
           ┌───┐
      q_1: ┤|0>├
           └───┘
      end
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [[1, "|0>"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤|0>├
           ├───┤
      q_1: ┤|0>├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["|0>", "|0>"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end
  end

  class Write1GateTest < GateTest
    test <<~TEST do
         ┌───┐
      q: ┤|1>├
         └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["|1>"]] }' }, as: :json

      assert_equal 2, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 1, amplitudes[1]
    end

    test <<~TEST do
      q_0: ─────
           ┌───┐
      q_1: ┤|1>├
           └───┘
      end
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [[1, "|1>"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 1, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤|1>├
           ├───┤
      q_1: ┤|1>├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "cols": [["|1>", "|1>"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 1, amplitudes[3]
    end
  end

  class MeasurementGateTest < GateTest
    test 'Measurement(0) 回路を計算' do
      get circuit_path, params: { circuit_json: '{ "cols": [["Measurement"]] }' }, as: :json

      assert_equal 2, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
    end

    test 'Measurement(1) 回路を計算' do
      get circuit_path, params: { circuit_json: '{ "cols": [[1, "Measurement"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test 'Measurement(1, 2) 回路を計算' do
      get circuit_path, params: { circuit_json: '{ "cols": [["Measurement", "Measurement"]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test '測定結果が 0' do
      get circuit_path, params: { circuit_json: '{ "cols": [["Measurement"]] }' }, as: :json

      assert_equal 0, measured_bits[0]
    end

    test '測定結果が 1' do
      get circuit_path, params: { circuit_json: '{ "cols": [["X"], ["Measurement"]] }' }, as: :json

      assert_equal 1, measured_bits[0]
    end
  end
end
