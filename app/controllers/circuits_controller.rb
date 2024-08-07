# frozen_string_literal: true

require 'simulator'

# コマンドラインで受け取った回路の JSON を表示し、ブラウザへプッシュ
class CircuitsController < ApplicationController
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/MethodLength
  def show
    @circuit_json = params['circuit_json']

    return unless @circuit_json

    circuit_data = JSON.parse(@circuit_json)
    qubit_count = circuit_data['cols'].map(&:length).max

    @step = params['step'] || (circuit_data['cols'].length - 1)

    @simulator = Simulator.new('0' * qubit_count)

    # 回路のそれぞれのステップを実行
    # rubocop:disable Metrics/BlockLength
    circuit_data['cols'].each_with_index do |each, step_index|
      break if step_index > @step

      each.each_with_index do |gate, bit|
        case gate
        when 1
          # nop
        when 'H'
          @simulator.h bit
        when 'X'
          controls = each.map.with_index { |each, index| index if each == '•' }.compact
          anti_controls = each.map.with_index { |each, index| index if each == '◦' }.compact

          if controls.length.positive? || anti_controls.length.positive?
            @simulator.cnot bit, controls, anti_controls
          else
            @simulator.x bit
          end
        when 'X^½'
          @simulator.rnot bit
        when 'Y'
          @simulator.y bit
        when 'Z'
          @simulator.z bit
        when /^P\((.+)\)/
          phi = Regexp.last_match(1)
          controls = each.map.with_index { |each, index| index if each == '•' }.compact

          if controls.length.positive?
            @simulator.cphase phi, bit, controls
          else
            @simulator.phase phi, bit
          end
        when '•'
          controls = each.map.with_index { |each, index| index if each == '•' }.compact
          non_controls = each.map.with_index { |each, index| index unless each == '•' }.compact

          @simulator.cz controls if controls.first == bit && controls.size > 1 && non_controls.empty?
        when '◦'
          # nop
        when 'Swap'
          swaps = each.map.with_index { |each, index| index if each == 'Swap' }.compact
          break if swaps.length != 2
          break if swaps.min != bit

          @simulator.swap swaps[0], swaps[1]
        when '|0>'
          @simulator.write 0, bit
        when '|1>'
          @simulator.write 1, bit
        when 'Measure'
          @simulator.measure bit
        else
          raise "Unknown gate: #{gate}"
        end
      end
    end
    # rubocop:enable Metrics/BlockLength

    CircuitJsonBroadcastJob.perform_now({ circuit_json: @circuit_json, step: @step, state_vector: @simulator.state })
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/MethodLength
end
