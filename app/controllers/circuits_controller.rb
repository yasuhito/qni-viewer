# frozen_string_literal: true

require 'simulator'

# コマンドラインで受け取った回路の JSON を表示し、ブラウザへプッシュ
#
# rubocop:disable Metrics/ClassLength
class CircuitsController < ApplicationController
  def show
    return unless params['circuit_json']

    circuit_json = extract_circuit_json
    setup_simulator(circuit_json)
    execute_simulator(circuit_json)
    broadcast_json(circuit_json)
  end

  private

  def extract_circuit_json
    circuit_json = params['circuit_json'].dup

    @circuit_json = JSON.generate(JSON.parse(circuit_json.to_unsafe_h.to_json))

    zero_all = ActiveModel::Type::Boolean.new.cast(params.fetch(:zero_all, true))
    measure_all = ActiveModel::Type::Boolean.new.cast(params.fetch(:measure_all, true))

    circuit_json['cols'] = [['|0>', '|0>', '|0>']] + circuit_json['cols'] if zero_all
    circuit_json['cols'] = circuit_json['cols'] + [%w[Measure Measure Measure]] if measure_all

    circuit_json
  end

  def setup_simulator(circuit_json)
    @step = params['step'] || (circuit_json['cols'].length - 1)
    @simulator = Simulator.new('0' * qubit_count(circuit_json))
    @connections = []
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def execute_simulator(circuit_json)
    circuit_json['cols'].each_with_index do |each, step_index|
      execute_step(each) if step_index <= @step

      # コントロールビットの接続を処理
      if each.include?('•')
        controlled_bits = each.each_with_index.with_object([]) do |(gate, bit), arr|
          arr << bit if gate == '•' || controlled_gate?(gate)
        end

        @connections << { step: step_index, endpoints: controlled_bits.minmax } if controlled_bits.size > 1
      end

      # SWAPゲート間の接続を処理
      next unless each.include?('Swap')

      swap_bits = each.each_with_index.with_object([]) do |(gate, bit), arr|
        arr << bit if gate == 'Swap'
      end

      @connections << { step: step_index, endpoints: swap_bits.minmax } if swap_bits.size == 2
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def broadcast_json(circuit_json)
    @modified_circuit_json = modify_circuit_json(JSON.generate(JSON.parse(circuit_json.to_unsafe_h.to_json)))

    CircuitJsonBroadcastJob.perform_now({
                                          circuit_json: @circuit_json,
                                          modified_circuit_json: @modified_circuit_json,
                                          step: @step,
                                          state_vector: @simulator.state
                                        })
  end

  def modify_circuit_json(circuit_json)
    parsed_circuit = JSON.parse(circuit_json)

    parsed_circuit['cols'].map! do |col|
      if col == ['Oracle3']
        %w[Bloch Bloch Bloch]
      elsif col.empty?
        ['…', '…', '…']
      else
        col
      end
    end

    JSON.generate(parsed_circuit)
  end

  def qubit_count(circuit_json)
    max_col_gates = circuit_json['cols'].map(&:length).max
    max_qft_span = max_qft_span(circuit_json)
    max_oracle_span = max_oracle_span(circuit_json)

    [max_col_gates, max_qft_span, max_oracle_span].max
  end

  def max_qft_span(circuit_json)
    circuit_json['cols'].each_with_object([]) do |col, spans|
      col.each do |gate|
        spans << gate.match(/^QFT(\d+)/)[1].to_i if gate.to_s.match(/^QFT(\d+)/)
      end
    end.max || 0
  end

  def max_oracle_span(circuit_json)
    circuit_json['cols'].each_with_object([]) do |col, spans|
      col.each do |gate|
        spans << gate.match(/^Oracle(\d+)/)[1].to_i if gate.to_s.match(/^Oracle(\d+)/)
      end
    end.max || 0
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def execute_step(step)
    # rubocop:disable Metrics/BlockLength
    step.each_with_index do |gate, bit|
      case gate
      when 1
        # nop
      when 'H'
        controls, anti_controls = extract_controls(step)
        @simulator.h bit, controls, anti_controls
      when 'X'
        controls, anti_controls = extract_controls(step)
        @simulator.x bit, controls, anti_controls
      when 'Y'
        controls, anti_controls = extract_controls(step)
        @simulator.y bit, controls, anti_controls
      when 'Z'
        controls, anti_controls = extract_controls(step)
        @simulator.z bit, controls, anti_controls
      when /^Rx\((.+)\)/
        theta = Regexp.last_match(1).to_f
        controls, anti_controls = extract_controls(step)
        @simulator.rx theta, bit, controls, anti_controls
      when /^Ry\((.+)\)/
        theta = Regexp.last_match(1).to_f
        controls, anti_controls = extract_controls(step)
        @simulator.ry theta, bit, controls, anti_controls
      when /^Rz\((.+)\)/
        theta = Regexp.last_match(1).to_f
        controls, anti_controls = extract_controls(step)
        @simulator.rz theta, bit, controls, anti_controls
      when /^P\((.+)\)/
        phi = Regexp.last_match(1).to_f
        controls, anti_controls = extract_controls(step)
        @simulator.phase phi, bit, controls, anti_controls
      when '•'
        controls, = extract_controls(step)
        non_controls = step.map.with_index { |each, index| index unless each == '•' }.compact

        @simulator.cz controls if controls.first == bit && controls.size > 1 && non_controls.empty?
      when '◦'
        # nop
      when 'Swap'
        swaps = step.map.with_index { |each, index| index if each == 'Swap' }.compact
        break if swaps.length != 2
        break if swaps.min != bit

        @simulator.swap swaps[0], swaps[1]
      when '|0>'
        @simulator.write 0, bit
      when '|1>'
        @simulator.write 1, bit
      when 'Measure'
        @simulator.measure bit
      when /^QFT(\d+)/
        span = Regexp.last_match(1).to_i
        @simulator.qft(bit, span)
      when /^Oracle(\d+)/
        span = Regexp.last_match(1).to_i
        @simulator.oracle(bit, span)
      else
        raise "Unknown gate: #{gate}"
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  def extract_controls(step)
    controls = step.map.with_index { |each, index| index if each == '•' }.compact
    anti_controls = step.map.with_index { |each, index| index if each == '◦' }.compact
    [controls, anti_controls]
  end

  def controlled_gate?(gate)
    %w[H X Y Z].include?(gate) ||
      gate.to_s.match?(/^(Rx|Ry|Rz|P)\(/)
  end
end
# rubocop:enable Metrics/ClassLength
