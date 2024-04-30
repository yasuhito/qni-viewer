# frozen_string_literal: true

require "state_vector"

class Simulator
  def initialize(bits)
    @bits = bits
    @state_vector = StateVector.new(@bits)
  end

  def state
    # @state_vector.matrix の各要素を複素数に変換した配列を返す
    @state_vector.matrix.to_a.map do |each|
      c = Complex(each)
      { real: c.real, imag: c.imag }
    end
  end
end
