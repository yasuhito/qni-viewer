# frozen_string_literal: true

require 'simulator'

# コマンドラインで受け取った回路の JSON を表示し、ブラウザへプッシュ
class CircuitsController < ApplicationController
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def show
    @circuit_json = params['circuit_json']

    return unless @circuit_json

    circuit_data = JSON.parse(@circuit_json)
    qubit_count = circuit_data['cols'].map(&:length).max

    @simulator = Simulator.new('0' * qubit_count)

    # 回路のそれぞれのステップを実行
    circuit_data['cols'].each do |each|
      each.each_with_index do |gate, bit|
        case gate
        when 1
          # nop
        when 'H'
          @simulator.h bit
        when 'X'
          controls = each.map.with_index { |each, index| index if each == '•' }.compact
          anti_controls = each.map.with_index { |each, index| index if each == '◦' }.compact

          if (controls.length > 0) || (anti_controls.length > 0)
            @simulator.cnot bit, controls, anti_controls
          else
            @simulator.x bit
          end
        when 'Y'
          @simulator.y bit
        when 'Z'
          @simulator.z bit
        when '•'
          # nop
        when '◦'
          # nop
        when '|0>'
          @simulator.write 0, bit
        when '|1>'
          @simulator.write 1, bit
        when 'Measurement'
          @simulator.measure bit
        else
          raise "Unknown gate: #{gate}"
        end
      end
    end

    CircuitJsonBroadcastJob.perform_now({ circuit_json: @circuit_json, state_vector: @simulator.state })
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
end
