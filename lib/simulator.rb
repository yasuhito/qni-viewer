# frozen_string_literal: true

require 'gate'
require 'keisan'
require 'state_vector'
require 'unicode_fraction'

# 量子回路シミュレータ
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

  def rnot(target_bit)
    @state_vector.apply_controlled_gate(Gate::RNOT, target_bit)
    self
  end

  def phase(phi, target_bit)
    calculator = Keisan::Calculator.new
    radian = calculator.evaluate(phi.gsub('π', 'x').gsub('_', '/'), x: Math::PI)

    cu Gate.phase(radian), target_bit
  end

  def cphase(phi, target_bit, controls)
    calculator = Keisan::Calculator.new
    radian = calculator.evaluate(phi.gsub('π', 'x').gsub('_', '/'), x: Math::PI)

    cu Gate.phase(radian), target_bit, controls
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
