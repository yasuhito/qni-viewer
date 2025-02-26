# frozen_string_literal: true

require 'test_helper'

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
      get circuit_path, params: { circuit_json: { cols: [['H']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal '√½', amplitudes[0].to_wolfram
      assert_equal '√½', amplitudes[1].to_wolfram
    end

    test <<~TEST do
      q_0: ─────
           ┌───┐
      q_1: ┤ H ├
           └───┘
      end
    TEST
      get circuit_path, params: { circuit_json: { cols: [[1, 'H']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal '√½', amplitudes[0].to_wolfram
      assert_equal 0, amplitudes[1]
      assert_equal '√½', amplitudes[2].to_wolfram
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ H ├
           ├───┤
      q_1: ┤ H ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [%w[H H]] }, zero_all: false, measure_all: false }, as: :json

      assert_equal '½', amplitudes[0].to_wolfram
      assert_equal '½', amplitudes[1].to_wolfram
      assert_equal '½', amplitudes[2].to_wolfram
      assert_equal '½', amplitudes[3].to_wolfram
    end

    test <<~TEST do
      q_0: ──■──
           ┌─┴─┐
      q_1: ┤ H ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['•', 'H']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 0, 'endpoints' => [0, 1] }, connections[0])
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ X ├──■──
           └───┘┌─┴─┐
      q_1: ─────┤ H ├
                └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['X'], ['•', 'H']] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal 0, amplitudes[0]
      assert_equal '√½', amplitudes[1].to_wolfram
      assert_equal 0, amplitudes[2]
      assert_equal '√½', amplitudes[3].to_wolfram

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 1, 'endpoints' => [0, 1] }, connections[0])
    end
  end

  class XGateTest < GateTest
    test <<~TEST do
         ┌───┐
      q: ┤ X ├
         └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['X']] }, zero_all: false, measure_all: false }, as: :json

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
      get circuit_path, params: { circuit_json: { cols: [[1, 'X']] }, zero_all: false, measure_all: false }, as: :json

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
      get circuit_path, params: { circuit_json: { cols: [%w[X X]] }, zero_all: false, measure_all: false }, as: :json

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
      get circuit_path, params: { circuit_json: { cols: [['Y']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 0, amplitudes[0]
      assert_equal 'i', amplitudes[1].to_wolfram
    end

    test <<~TEST do
      q_0: ─────
           ┌───┐
      q_1: ┤ Y ├
           └───┘
      end
    TEST
      get circuit_path, params: { circuit_json: { cols: [[1, 'Y']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 'i', amplitudes[2].to_wolfram
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ Y ├
           ├───┤
      q_1: ┤ Y ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [%w[Y Y]] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal(-1, amplitudes[3])
    end

    test <<~TEST do
      q_0: ──■──
           ┌─┴─┐
      q_1: ┤ Y ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['•', 'Y']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 0, 'endpoints' => [0, 1] }, connections[0])
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ X ├──■──
           └───┘┌─┴─┐
      q_1: ─────┤ Y ├
                └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['X'], ['•', 'Y']] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 'i', amplitudes[3].to_wolfram

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 1, 'endpoints' => [0, 1] }, connections[0])
    end
  end

  class ZGateTest < GateTest
    test <<~TEST do
         ┌───┐
      q: ┤ Z ├
         └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['Z']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
    end

    test <<~TEST do
         ┌───┐┌───┐
      q: ┤ H ├┤ Z ├
         └───┘└───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['H'], ['Z']] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal '√½', amplitudes[0].to_wolfram
      assert_equal '-√½', amplitudes[1].to_wolfram
    end

    test <<~TEST do
      q_0: ─────
           ┌───┐
      q_1: ┤ Z ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [[1, 'Z']] }, zero_all: false, measure_all: false }, as: :json

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
      get circuit_path, params: { circuit_json: { cols: [%w[Z Z]] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
      q_0: ──■──
           ┌─┴─┐
      q_1: ┤ Z ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['•', 'Z']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 0, 'endpoints' => [0, 1] }, connections[0])
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ X ├──■──
           └───┘┌─┴─┐
      q_1: ─────┤ Z ├
                └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['X'], ['•', 'Z']] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal 0, amplitudes[0]
      assert_equal 1, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 1, 'endpoints' => [0, 1] }, connections[0])
    end
  end

  class CzGateTest < GateTest
    test <<~TEST do
      q_0: ─■─
            │
      q_1: ─■─
    TEST
      get circuit_path, params: { circuit_json: { cols: [['•', '•']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 0, 'endpoints' => [0, 1] }, connections[0])
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ H ├─■─
           ├───┤ │
      q_1: ┤ H ├─■─
           └───┘
    TEST
      get circuit_path,
          params: { circuit_json: { cols: [['H', 'H'], ['•', '•']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal '½', amplitudes[0].to_wolfram
      assert_equal '½', amplitudes[1].to_wolfram
      assert_equal '½', amplitudes[2].to_wolfram
      assert_equal '-½', amplitudes[3].to_wolfram

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 1, 'endpoints' => [0, 1] }, connections[0])
    end
  end

  class PhaseGateTest < GateTest
    test <<~TEST do
         ┌────────┐
      q: ┤ P(π/2) ├
         └────────┘
    TEST
      get circuit_path,
          params: { circuit_json: { cols: [['P(1.5707963267948966)']] }, zero_all: false, measure_all: false },
          as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
    end

    test <<~TEST do
         ┌─────────┐
      q: ┤ P(-π/2) ├
         └─────────┘
    TEST
      get circuit_path,
          params: { circuit_json: { cols: [['P(-1.5707963267948966)']] }, zero_all: false, measure_all: false },
          as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
    end

    test <<~TEST do
         ┌───┐┌────────┐
      q: ┤ H ├┤ P(π/2) ├
         └───┘└────────┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['H'], ['P(1.5707963267948966)']] },
                                  zero_all: false,
                                  measure_all: false },
                        as: :json

      assert_equal '√½', amplitudes[0].to_wolfram
      assert_equal '√½i', amplitudes[1].to_wolfram
    end
  end

  class CnotGateTest < GateTest
    test <<~TEST do
      q_0: ──■──
           ┌─┴─┐
      q_1: ┤ X ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['•', 'X']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 1, amplitudes[0b00]
      assert_equal 0, amplitudes[0b01]
      assert_equal 0, amplitudes[0b10]
      assert_equal 0, amplitudes[0b11]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 0, 'endpoints' => [0, 1] }, connections[0])
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ X ├──■──
           └───┘┌─┴─┐
      q_1: ─────┤ X ├
                └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['X'], ['•', 'X']] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal 0, amplitudes[0b00]
      assert_equal 0, amplitudes[0b01]
      assert_equal 0, amplitudes[0b10]
      assert_equal 1, amplitudes[0b11]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 1, 'endpoints' => [0, 1] }, connections[0])
    end
  end

  class AntiCnotGateTest < GateTest
    test <<~TEST do
      q_0: ──□──
           ┌─┴─┐
      q_1: ┤ X ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['◦', 'X']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 0, amplitudes[0b00]
      assert_equal 0, amplitudes[0b01]
      assert_equal 1, amplitudes[0b10]
      assert_equal 0, amplitudes[0b11]
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ X ├──□──
           └───┘┌─┴─┐
      q_1: ─────┤ X ├
                └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['X'], ['◦', 'X']] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal 0, amplitudes[0b00]
      assert_equal 1, amplitudes[0b01]
      assert_equal 0, amplitudes[0b10]
      assert_equal 0, amplitudes[0b11]
    end
  end

  class SwapGateTest < GateTest
    test <<~TEST do
           ┌───┐
      q_0: ┤ X ├─X─
           └───┘ │
      q_1: ──────X─
    TEST
      get circuit_path,
          params: { circuit_json: { cols: [['X'], %w[Swap Swap]] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 1, amplitudes[2]
      assert_equal 0, amplitudes[3]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 1, 'endpoints' => [0, 1] }, connections[0])
    end

    test <<~TEST do
      q_0: ──────X─
           ┌───┐ │
      q_1: ┤ X ├─X─
           └───┘
    TEST
      get circuit_path,
          params: { circuit_json: { cols: [[1, 'X'], %w[Swap Swap]] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 0, amplitudes[0]
      assert_equal 1, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 1, 'endpoints' => [0, 1] }, connections[0])
    end
  end

  class Write0GateTest < GateTest
    test <<~TEST do
         ┌───┐
      q: ┤|0>├
         └───┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['|0>']] }, zero_all: false, measure_all: false }, as: :json

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
      get circuit_path, params: { circuit_json: { cols: [[1, '|0>']] }, zero_all: false, measure_all: false }, as: :json

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
      get circuit_path, params: { circuit_json: { cols: [['|0>', '|0>']] }, zero_all: false, measure_all: false },
                        as: :json

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
      get circuit_path, params: { circuit_json: { cols: [['|1>']] }, zero_all: false, measure_all: false }, as: :json

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
      get circuit_path, params: { circuit_json: { cols: [[1, '|1>']] }, zero_all: false, measure_all: false }, as: :json

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
      get circuit_path, params: { circuit_json: { cols: [['|1>', '|1>']] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 1, amplitudes[3]
    end
  end

  class MeasurementGateTest < GateTest
    test <<~TEST do
         ┌─┐
      q: ┤M├
         └─┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['Measure']] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
    end

    test <<~TEST do
      q_0: ───
           ┌─┐
      q_1: ┤M├
           └─┘
      end
    TEST
      get circuit_path, params: { circuit_json: { cols: [[1, 'Measure']] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
           ┌─┐
      q_0: ┤M├
           ├─┤
      q_1: ┤M├
           └─┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [%w[Measure Measure]] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test '測定結果が 0' do
      get circuit_path, params: { circuit_json: { cols: [['Measure']] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal 0, measured_bits[0]
    end

    test '測定結果が 1' do
      get circuit_path, params: { circuit_json: { cols: [['X'], ['Measure']] }, zero_all: false, measure_all: false },
                        as: :json

      assert_equal 1, measured_bits[0]
    end

    test 'QFT3' do
      get circuit_path, params: { circuit_json: { cols: [['QFT3']] }, zero_all: false, measure_all: false }, as: :json

      assert_equal 8, amplitudes.length
      assert_equal '√⅛', amplitudes[0].to_wolfram
      assert_equal '√⅛', amplitudes[1].to_wolfram
      assert_equal '√⅛', amplitudes[2].to_wolfram
      assert_equal '√⅛', amplitudes[3].to_wolfram
      assert_equal '√⅛', amplitudes[4].to_wolfram
      assert_equal '√⅛', amplitudes[5].to_wolfram
      assert_equal '√⅛', amplitudes[6].to_wolfram
      assert_equal '√⅛', amplitudes[7].to_wolfram
    end

    test 'Oracle3' do
      get circuit_path,
          params: { circuit_json: { cols: [%w[H H H], ['Oracle3']] }, zero_all: false, measure_all: false },
          as: :json

      assert_equal 8, amplitudes.length
      assert_equal '√⅛', amplitudes[0].to_wolfram
      assert_equal '√⅛', amplitudes[1].to_wolfram
      assert_equal '√⅛', amplitudes[2].to_wolfram
      assert_equal '√⅛', amplitudes[3].to_wolfram
      assert_equal '√⅛', amplitudes[4].to_wolfram
      assert_equal '√⅛', amplitudes[5].to_wolfram
      assert_equal '-√⅛', amplitudes[6].to_wolfram
      assert_equal '√⅛', amplitudes[7].to_wolfram
    end
  end

  class RxGateTest < GateTest
    test <<~TEST do
         ┌───────┐
      q: ┤ Rx(π) ├
         └───────┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['Rx(3.141592653589793)']] },
                                  zero_all: false, measure_all: false }, as: :json

      assert_equal '0', amplitudes[0].to_wolfram
      assert_equal '-i', amplitudes[1].to_wolfram
    end

    test <<~TEST do
      q_0: ──■──────
           ┌──┴──┐
      q_1: ┤ Rx(π) ├
           └──────┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['•', 'Rx(3.141592653589793)']] },
                                  zero_all: false, measure_all: false }, as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 0, 'endpoints' => [0, 1] }, connections[0])
    end
  end

  class RyGateTest < GateTest
    test <<~TEST do
         ┌───────┐
      q: ┤ Ry(π) ├
         └───────┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['Ry(3.141592653589793)']] },
                                  zero_all: false, measure_all: false }, as: :json

      assert_equal '0', amplitudes[0].to_wolfram
      assert_equal 1, amplitudes[1]
    end

    test <<~TEST do
      q_0: ──■──────
           ┌──┴──┐
      q_1: ┤ Ry(π) ├
           └──────┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['•', 'Ry(3.141592653589793)']] },
                                  zero_all: false, measure_all: false }, as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 0, 'endpoints' => [0, 1] }, connections[0])
    end
  end

  class RzGateTest < GateTest
    test <<~TEST do
         ┌───────┐
      q: ┤ Rz(π) ├
         └───────┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['Rz(3.141592653589793)']] },
                                  zero_all: false, measure_all: false }, as: :json

      assert_equal '-i', amplitudes[0].to_wolfram
      assert_equal 0, amplitudes[1]
    end

    test <<~TEST do
      q_0: ──■──────
           ┌──┴──┐
      q_1: ┤ Rz(π) ├
           └──────┘
    TEST
      get circuit_path, params: { circuit_json: { cols: [['•', 'Rz(3.141592653589793)']] },
                                  zero_all: false, measure_all: false }, as: :json

      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]

      connections = JSON.parse(@response.body).fetch('connections')
      assert_equal 1, connections.length
      assert_equal({ 'step' => 0, 'endpoints' => [0, 1] }, connections[0])
    end
  end
end
