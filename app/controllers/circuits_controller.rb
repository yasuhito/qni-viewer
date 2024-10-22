# frozen_string_literal: true

require 'simulator'

# コマンドラインで受け取った回路の JSON を表示し、ブラウザへプッシュ
class CircuitsController < ApplicationController
  def show
    circuit_json = params['circuit_json']

    return unless circuit_json

    @circuit_json = JSON.generate(JSON.parse(params['circuit_json'].to_unsafe_h.to_json))
    @step = params['step'] || (circuit_json['cols'].length - 1)
    @simulator = Simulator.new('0' * qubit_count(circuit_json))

    circuit_json['cols'].each_with_index do |each, step_index|
      break if step_index > @step

      execute_step(each)
    end
    CircuitJsonBroadcastJob.perform_now({ circuit_json: @circuit_json, step: @step,
                                          state_vector: @simulator.state })
  end

  private

  def qubit_count(circuit_json)
    max_col_gates = circuit_json['cols'].map(&:length).max
    max_qft_span = circuit_json['cols'].flat_map { |col| col.select { |gate| gate.to_s.match(/^QFT(\d+)/) } }
                                       .map { |gate| gate.match(/^QFT(\d+)/)[1].to_i }
                                       .max || 0

    [max_col_gates, max_qft_span].max
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
        @simulator.h bit
      when 'X'
        controls = step.map.with_index { |each, index| index if each == '•' }.compact
        anti_controls = step.map.with_index { |each, index| index if each == '◦' }.compact

        if controls.length.positive? || anti_controls.length.positive?
          @simulator.cnot bit, controls, anti_controls
        else
          @simulator.x bit
        end
      when 'Y'
        @simulator.y bit
      when 'Z'
        @simulator.z bit
      when /^P\((.+)\)/
        phi = Regexp.last_match(1).to_f
        controls = step.map.with_index { |each, index| index if each == '•' }.compact

        if controls.length.positive?
          @simulator.cphase phi, bit, controls
        else
          @simulator.phase phi, bit
        end
      when '•'
        controls = step.map.with_index { |each, index| index if each == '•' }.compact
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
      else
        raise "Unknown gate: #{gate}"
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
end
