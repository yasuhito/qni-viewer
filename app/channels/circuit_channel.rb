# frozen_string_literal: true

# ユーザから受け取った回路 JSON を流すチャンネル
class CircuitChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'circuit_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update(data)
    ActionCable.server.broadcast('circuit_channel', { circuit_json: data['circuit_json'] })
  end
end
