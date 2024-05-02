# frozen_string_literal: true

# 回路の JSON データを ActionCable でブロードキャスト
class CircuitJsonBroadcastJob < ApplicationJob
  queue_as :default

  def perform(circuit_json)
    ActionCable.server.broadcast 'circuit_channel', { circuit_json: circuit_json }
  end
end
