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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "H"}]] }' }, as: :json

      assert_equal 2, amplitudes.length
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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": 1}, {"gate": "H"}]] }' }, as: :json

      assert_equal 4, amplitudes.length
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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "H"}, {"gate": "H"}]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal '½', amplitudes[0].to_wolfram
      assert_equal '½', amplitudes[1].to_wolfram
      assert_equal '½', amplitudes[2].to_wolfram
      assert_equal '½', amplitudes[3].to_wolfram
    end
  end

  class XGateTest < GateTest
    test <<~TEST do
         ┌───┐
      q: ┤ X ├
         └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "X"}]] }' }, as: :json

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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": 1}, {"gate": "X"}]] }' }, as: :json

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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "X"}, {"gate": "X"}]] }' }, as: :json

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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "Y"}]] }' }, as: :json

      assert_equal 2, amplitudes.length
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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": 1}, {"gate": "Y"}]] }' }, as: :json

      assert_equal 4, amplitudes.length
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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "Y"}, {"gate": "Y"}]] }' }, as: :json

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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "Z"}]] }' }, as: :json

      assert_equal 2, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
    end

    test <<~TEST do
         ┌───┐┌───┐
      q: ┤ H ├┤ Z ├
         └───┘└───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "H"}], [{"gate": "Z"}]] }' }, as: :json

      assert_equal 2, amplitudes.length
      assert_equal '√½', amplitudes[0].to_wolfram
      assert_equal '-√½', amplitudes[1].to_wolfram
    end

    test <<~TEST do
      q_0: ─────
           ┌───┐
      q_1: ┤ Z ├
           └───┘
      end
    TEST
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": 1}, {"gate": "Z"}]] }' }, as: :json

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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "Z"}, {"gate": "Z"}]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end
  end

  class CzGateTest < GateTest
    test <<~TEST do
      q_0: ─■─
            │
      q_1: ─■─
    TEST
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "•"}, {"gate": "•"}]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ H ├─■─
           ├───┤
      q_1: ┤ H ├─■─
           └───┘
    TEST
      get circuit_path,
          params: {
            circuit_json: '{ "circuit": [[{"gate": "H"}, {"gate": "H"}], [{"gate": "•"}, {"gate": "•"}]] }'
          }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal '½', amplitudes[0].to_wolfram
      assert_equal '½', amplitudes[1].to_wolfram
      assert_equal '½', amplitudes[2].to_wolfram
      assert_equal '-½', amplitudes[3].to_wolfram
    end
  end

  class PhaseGateTest < GateTest
    test <<~TEST do
         ┌────────┐
      q: ┤ P(π/2) ├
         └────────┘
    TEST
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "Phase", "phi": 1.5707963267948966}]] }' },
                        as: :json

      assert_equal 2, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
    end

    test <<~TEST do
         ┌─────────┐
      q: ┤ P(-π/2) ├
         └─────────┘
    TEST
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "Phase", "phi": -1.5707963267948966}]] }' },
                        as: :json

      assert_equal 2, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
    end

    test <<~TEST do
         ┌───┐┌────────┐
      q: ┤ H ├┤ P(π/2) ├
         └───┘└────────┘
    TEST
      get circuit_path,
          params: { circuit_json: '{ "circuit": [[{"gate": "H"}], [{"gate": "Phase", "phi": 1.5707963267948966}]] }' },
          as: :json

      assert_equal 2, amplitudes.length
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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "•"}, {"gate": "X"}]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 1, amplitudes[0b00]
      assert_equal 0, amplitudes[0b01]
      assert_equal 0, amplitudes[0b10]
      assert_equal 0, amplitudes[0b11]
    end

    test <<~TEST do
           ┌───┐
      q_0: ┤ X ├──■──
           └───┘┌─┴─┐
      q_1: ─────┤ X ├
                └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "X"}], [{"gate": "•"}, {"gate": "X"}]] }' },
                        as: :json

      assert_equal 4, amplitudes.length
      assert_equal 0, amplitudes[0b00]
      assert_equal 0, amplitudes[0b01]
      assert_equal 0, amplitudes[0b10]
      assert_equal 1, amplitudes[0b11]
    end
  end

  class AntiCnotGateTest < GateTest
    test <<~TEST do
      q_0: ──□──
           ┌─┴─┐
      q_1: ┤ X ├
           └───┘
    TEST
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "◦"}, {"gate": "X"}]] }' }, as: :json

      assert_equal 4, amplitudes.length
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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "X"}], [{"gate": "◦"}, {"gate": "X"}]] }' },
                        as: :json

      assert_equal 4, amplitudes.length
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
          params: { circuit_json: '{ "circuit": [[{"gate": "X"}], [{"gate": "Swap"}, {"gate": "Swap"}]] }' }, as: :json

      assert_equal 4, amplitudes.length
      assert_equal 0, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 1, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test <<~TEST do
      q_0: ──────X─
           ┌───┐ │
      q_1: ┤ X ├─X─
           └───┘
    TEST
      get circuit_path,
          params: {
            circuit_json: '{ "circuit": [[{"gate": 1}, {"gate": "X"}], [{"gate": "Swap"}, {"gate": "Swap"}]] }'
          }, as: :json

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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "|0>"}]] }' }, as: :json

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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": 1}, {"gate": "|0>"}]] }' }, as: :json

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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "|0>"}, {"gate": "|0>"}]] }' }, as: :json

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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "|1>"}]] }' }, as: :json

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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": 1}, {"gate": "|1>"}]] }' }, as: :json

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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "|1>"}, {"gate": "|1>"}]] }' }, as: :json

      assert_equal 4, amplitudes.length
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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "Measure"}]] }' }, as: :json

      assert_equal 2, amplitudes.length
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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": 1}, {"gate": "Measure"}]] }' }, as: :json

      assert_equal 4, amplitudes.length
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
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "Measure"}, {"gate": "Measure"}]] }' },
                        as: :json

      assert_equal 4, amplitudes.length
      assert_equal 1, amplitudes[0]
      assert_equal 0, amplitudes[1]
      assert_equal 0, amplitudes[2]
      assert_equal 0, amplitudes[3]
    end

    test '測定結果が 0' do
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "Measure"}]] }' }, as: :json

      assert_equal 0, measured_bits[0]
    end

    test '測定結果が 1' do
      get circuit_path, params: { circuit_json: '{ "circuit": [[{"gate": "X"}], [{"gate": "Measure"}]] }' }, as: :json

      assert_equal 1, measured_bits[0]
    end
  end
end
