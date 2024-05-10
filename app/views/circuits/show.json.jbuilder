# frozen_string_literal: true

json.set! :state_vector do
  json.array! @simulator.state
end

json.set! :measured_bits do
  json.array! @simulator.measured_bits
end
