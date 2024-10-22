# frozen_string_literal: true

require 'gate'
require 'state_vector'
require 'unicode_fraction'

# 量子回路シミュレータ
#
# rubocop:disable Metrics/ClassLength
class Simulator
  attr_reader :measured_bits

  def initialize(bits)
    @bits = bits
    @state_vector = StateVector.new(@bits)
    @measured_bits = []
  end

  def h(target_bit)
    @state_vector.apply_controlled_gate(Gate::H, target_bit)
    self
  end

  def x(target_bit)
    @state_vector.apply_controlled_gate(Gate::X, target_bit)
    self
  end

  def y(target_bit)
    @state_vector.apply_controlled_gate(Gate::Y, target_bit)
    self
  end

  def z(target_bit)
    @state_vector.apply_controlled_gate(Gate::Z, target_bit)
    self
  end

  def cz(targets)
    controls = targets[1..]
    target_bit = targets[0]

    @state_vector.apply_controlled_gate(Gate::Z, target_bit, controls)
    self
  end

  def phase(phi, target_bit)
    cu Gate.phase(phi), target_bit
    self
  end

  def cphase(phi, target_bit, controls)
    cu Gate.phase(phi), target_bit, controls
    self
  end

  def cnot(target_bit, controls, anti_controls = [])
    cu Gate::X, target_bit, controls, anti_controls

    self
  end

  def swap(target0, target1)
    cnot(target0, [target1]).cnot(target1, [target0]).cnot(target0, [target1])
    self
  end

  def write(value, target_bit)
    p_zero = probability_zero(target_bit).round(5)
    x(target_bit) if (value.zero? && p_zero.zero?) || (value == 1 && p_zero == 1)
    self
  end

  def measure(target_bit)
    p_zero = probability_zero(target_bit)

    if rand <= p_zero
      (0...(1 << @state_vector.qubit_count)).each do |each|
        @state_vector.set_amplifier(each, Complex(0, 0)) if (each & (1 << target_bit)) != 0
        @state_vector.set_amplifier(each, @state_vector.amplifier(each) / Math.sqrt(p_zero))
      end
      @measured_bits[target_bit] = 0
    else
      (0...(1 << @state_vector.qubit_count)).each do |each|
        @state_vector.set_amplifier(each, Complex(0, 0)) if (each & (1 << target_bit)).zero?
        @state_vector.set_amplifier(each, @state_vector.amplifier(each) / Math.sqrt(1 - p_zero))
      end
      @measured_bits[target_bit] = 1
    end

    self
  end

  def qft(target_bit, span)
    raise "QFT with target_bit #{target_bit} is not supported" if target_bit != 0
    raise "QFT with span #{span} is not supported" if span != 3

    h(target_bit + 2)
      .cphase(-Math::PI / 2, target_bit + 1, [target_bit + 2])
      .h(target_bit + 1)
      .cphase(-Math::PI / 4, target_bit, [target_bit + 2])
      .cphase(-Math::PI / 2, target_bit, [target_bit + 1])
      .h(target_bit)
      .swap(target_bit, target_bit + 2)

    self
  end

  def oracle(target_bit, span)
    raise "Oracle with target_bit #{target_bit} is not supported" if target_bit != 0
    raise "Oracle with span #{span} is not supported" if span != 3

    h(0).h(1).h(2)
        .x(0).x(1).x(2)
        .cz([0, 1, 2])
        .x(0).x(1).x(2)
        .h(0).h(1).h(2)

    self
  end

  def state
    @state_vector.map do |real, imag|
      c = Complex(real, imag)
      { magnitude: (c.real**2) + (c.imag**2), phaseDeg: (Math.atan2(c.imag, c.real) / Math::PI) * 180, real: c.real,
        imag: c.imag }
    end
  end

  def qubit_count
    @state_vector.qubit_count
  end

  private

  def cu(gate, target_bit, controls = [], anti_controls = [])
    @state_vector.apply_controlled_gate(gate, target_bit, controls, anti_controls)
  end

  def probability_zero(target_bit)
    probability = 0

    (0...(1 << @state_vector.qubit_count)).each do |each|
      probability += @state_vector.amplifier(each).abs**2 if (each & (1 << target_bit)).zero?
    end

    probability
  end
end
# rubocop:enable Metrics/ClassLength
