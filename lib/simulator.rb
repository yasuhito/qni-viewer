# frozen_string_literal: true

require 'state_vector'
require 'matrix'
require 'keisan'

# 量子回路シミュレータ
# rubocop:disable Metrics/ClassLength
class Simulator
  # TODO: 適切なクラスに移動
  H = Matrix[[1, 1],
             [1, -1]] * Math.sqrt(0.5)
  X = Matrix[[0, 1],
             [1, 0]]
  Y = Matrix[[0, -Complex::I],
             [Complex::I, 0]]
  Z = Matrix[[1, 0],
             [0, -1]]

  attr_reader :measured_bits

  def initialize(bits)
    @bits = bits
    @state_vector = StateVector.new(@bits)
    @measured_bits = []
  end

  def h(target_bit)
    @state_vector = times_qubit_operation(H, target_bit)
    self
  end

  def x(target_bit)
    @state_vector = times_qubit_operation(X, target_bit)
    self
  end

  def y(target_bit)
    @state_vector = times_qubit_operation(Y, target_bit)
    self
  end

  def z(target_bit)
    @state_vector = times_qubit_operation(Z, target_bit)
    self
  end

  def phase(phi, target_bit)
    calculator = Keisan::Calculator.new
    radian = calculator.evaluate(phi.gsub('π', 'x'), x: Math::PI)
    phase = Matrix[[1, 0],
                   [0, Math::E**(Complex::I * radian)]]

    cu([], phase, target_bit)
  end

  def cnot(target_bit, controls, anti_controls)
    anti_controls.each do |each|
      @state_vector = times_qubit_operation(X, each)
    end
    cu controls + anti_controls, X, target_bit
    anti_controls.each do |each|
      @state_vector = times_qubit_operation(X, each)
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
        @state_vector[each] = Complex(0, 0) if (each & (1 << target_bit)) != 0
        @state_vector[each] = @state_vector[each] / Math.sqrt(p_zero)
      end
      @measured_bits[target_bit] = 0
    else
      (0...(1 << @state_vector.qubit_count)).each do |each|
        @state_vector[each] = Complex(0, 0) if (each & (1 << target_bit)).zero?
        @state_vector[each] = @state_vector[each] / Math.sqrt(1 - p_zero)
      end
      @measured_bits[target_bit] = 1
    end

    self
  end

  def state
    # @state_vector の各要素を複素数に変換した配列を返す
    @state_vector.map do |each|
      c = Complex(each)
      { real: c.real, imag: c.imag }
    end
  end

  private

  def times_qubit_operation(gate, target_bit, control_mask = 0, desigred_value_mask = 0)
    ar = gate[0, 0].real
    ai = gate[0, 0].imag
    br = gate[0, 1].real
    bi = gate[0, 1].imag
    cr = gate[1, 0].real
    ci = gate[1, 0].imag
    dr = gate[1, 1].real
    di = gate[1, 1].imag

    i = 0
    (0...@state_vector.size).each do |row|
      is_controlled = ((control_mask & row) ^ desigred_value_mask) != 0
      qubit_val = (row & (1 << target_bit)) != 0

      if !is_controlled && !qubit_val
        j = i + ((1 << target_bit) * 2)

        xr = @state_vector[i / 2].real
        xi = @state_vector[i / 2].imag
        yr = @state_vector[j / 2].real
        yi = @state_vector[j / 2].imag

        @state_vector[i / 2] = Complex((xr * ar) - (xi * ai) + (yr * br) - (yi * bi),
                                       (xr * ai) + (xi * ar) + (yr * bi) + (yi * br))
        @state_vector[j / 2] =
          Complex((xr * cr) - (xi * ci) + (yr * dr) - (yi * di), (xr * ci) + (xi * cr) + (yr * di) + (yi * dr))
      end

      i += 2
    end

    @state_vector
  end

  def cu(controls, gate, target_bit)
    control_mask = controls.reduce(0) do |result, each|
      result | (1 << each)
    end

    times_qubit_operation(gate, target_bit, control_mask, control_mask)
  end

  def probability_zero(target_bit)
    probability = 0

    (0...(1 << @state_vector.qubit_count)).each do |each|
      probability += @state_vector[each].abs**2 if (each & (1 << target_bit)).zero?
    end

    probability
  end
end
# rubocop:enable Metrics/ClassLength
