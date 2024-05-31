# frozen_string_literal: true

require 'keisan'
require 'matrix'
require 'state_vector'
require 'unicode_fraction'

# 量子回路シミュレータ
# rubocop:disable Metrics/ClassLength
class Simulator
  def self.i
    Complex::I
  end

  # TODO: 適切なクラスに移動
  H = Matrix[[1, 1],
             [1, -1]] * UnicodeFraction('√½')
  X = Matrix[[0, 1],
             [1, 0]]
  Y = Matrix[[0, -i],
             [i, 0]]
  Z = Matrix[[1, 0],
             [0, -1]]
  RNOT = Matrix[[i + 1, -i + 1],
                [-i + 1, i + 1]] * UnicodeFraction('½')

  attr_reader :measured_bits

  def i
    self.class.i
  end

  def e
    Math::E
  end

  def initialize(bits)
    @bits = bits
    @state_vector = StateVector.new(@bits)
    @measured_bits = []
  end

  def h(target_bit)
    @state_vector.apply_controlled_gate(H, target_bit)
    self
  end

  def x(target_bit)
    @state_vector.apply_controlled_gate(X, target_bit)
    self
  end

  def y(target_bit)
    @state_vector.apply_controlled_gate(Y, target_bit)
    self
  end

  def z(target_bit)
    @state_vector.apply_controlled_gate(Z, target_bit)
    self
  end

  def cz(targets)
    controls = targets[1..]
    target_bit = targets[0]

    @state_vector.apply_controlled_gate(Z, target_bit, controls)
    self
  end

  def rnot(target_bit)
    @state_vector.apply_controlled_gate(RNOT, target_bit)
    self
  end

  def phase(phi, target_bit)
    calculator = Keisan::Calculator.new
    radian = calculator.evaluate(phi.gsub('π', 'x'), x: Math::PI)
    phase = Matrix[[1, 0],
                   [0, e**(i * radian)]]

    cu([], phase, target_bit)
  end

  def cnot(target_bit, controls, anti_controls)
    anti_controls.each do |each|
      @state_vector.apply_controlled_gate(X, each)
    end
    cu controls + anti_controls, X, target_bit
    anti_controls.each do |each|
      @state_vector.apply_controlled_gate(X, each)
    end

    self
  end

  def swap(target0, target1)
    cnot(target0, [target1], []).cnot(target1, [target0], []).cnot(target0, [target1], [])
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

  def cu(controls, gate, target_bit)
    @state_vector.apply_controlled_gate(gate, target_bit, controls)
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
