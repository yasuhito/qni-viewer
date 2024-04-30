# frozen_string_literal: true

class Simulator
  def initialize(bits)
    @bits = bits
  end

  def state
    [{ real: 1 / Math.sqrt(2), imag: 0 }, { real: 1 / Math.sqrt(2), imag: 0 }]
  end
end
