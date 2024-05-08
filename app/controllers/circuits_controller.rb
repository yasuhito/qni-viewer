# frozen_string_literal: true

require 'simulator'

# コマンドラインで受け取った回路の JSON を表示し、ブラウザへプッシュ
class CircuitsController < ApplicationController
  def show
    @circuit_json = params['circuit_json']
    @simulator = Simulator.new(params['qubit_count'] ? '0' * params['qubit_count'].to_i : '0')

    return unless @circuit_json

    Rails.logger.debug(@circuit_json.inspect)
    circuit_data = JSON.parse(@circuit_json)

    # 回路のそれぞれのステップを実行
    circuit_data['cols'].each do |each|
      each.each_with_index do |gate, bit|
        case gate
        when 'I'
          # nop
        when 'H'
          Rails.logger.debug { "#{gate} (qubit #{bit})" }
          @simulator.h bit
        else
          raise "Unknown gate: #{gate}"
        end
      end
    end

    CircuitJsonBroadcastJob.perform_now({ circuit_json: @circuit_json, state_vector: @simulator.state })
  end
end
