# frozen_string_literal: true

require 'simulator'

# コマンドラインで受け取った回路の JSON を表示し、ブラウザへプッシュ
class CircuitsController < ApplicationController
  def show
    @circuit_json = params['circuit_json']
    @simulator = Simulator.new('0' * params['qubitCount'].to_i)

    return unless @circuit_json

    CircuitJsonBroadcastJob.perform_now @circuit_json
  end
end
