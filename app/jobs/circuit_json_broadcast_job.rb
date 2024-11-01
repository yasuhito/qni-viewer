# frozen_string_literal: true

# 回路の JSON データを ActionCable でブロードキャスト
class CircuitJsonBroadcastJob < ApplicationJob
  queue_as :default

  def perform(data)
    ActionCable.server.broadcast 'circuit_channel',
                                 { circuit_json: data[:circuit_json],
                                   modified_circuit_json: data[:modified_circuit_json],
                                   step: data[:step],
                                   state_vector: data[:state_vector] }
  end
end
