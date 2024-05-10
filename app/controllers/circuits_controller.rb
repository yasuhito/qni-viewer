# frozen_string_literal: true

require 'simulator'

# コマンドラインで受け取った回路の JSON を表示し、ブラウザへプッシュ
class CircuitsController < ApplicationController
  def show
    @circuit_json = params['circuit_json']
    Rails.logger.debug { "circuit_json = #{@circuit_json.inspect}" }

    return unless @circuit_json

    circuit_data = JSON.parse(@circuit_json)
    Rails.logger.debug(circuit_data.inspect)
    Rails.logger.debug(circuit_data['cols'][0].inspect)

    qubit_count = circuit_data['cols'].map(&:length).max

    Rails.logger.debug { "qubit_count = #{qubit_count}" }

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
          @simulator.x bit
        when 'Y'
          @simulator.y bit
        when 'Z'
          @simulator.z bit
        when '|0>'
          @simulator.write 0, bit
        when '|1>'
          @simulator.write 1, bit
        when 'Measurement'
          @simulator.measure bit
        else
          raise "Unknown gate: #{gate}"
        end

        Rails.logger.debug { "#{gate} (qubit #{bit})" }
      end
    end

    CircuitJsonBroadcastJob.perform_now({ circuit_json: @circuit_json, state_vector: @simulator.state })
  end
end
