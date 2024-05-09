# frozen_string_literal: true

require 'state_vector'
require 'matrix'

# 量子回路シミュレータ
class Simulator
  # TODO: 適切なクラスに移動
  H = Matrix[[1 / Math.sqrt(2), 1 / Math.sqrt(2)],
             [1 / Math.sqrt(2), -1 / Math.sqrt(2)]]
  X = Matrix[[0, 1],
             [1, 0]]

  def initialize(bits)
    @bits = bits
    @state_vector = StateVector.new(@bits)
  end

  def h(target_bit)
    @state_vector = times_qubit_operation(H, target_bit)
    self
  end

  def x(target_bit)
    @state_vector = times_qubit_operation(X, target_bit)
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

  def times_qubit_operation(gate, target_bit)
    Rails.logger.debug { "target_bit = #{target_bit}" }

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
      qubit_val = (row & (1 << target_bit)) != 0
      # col = 0
      # Rails.logger.debug { "row, col = #{row}, #{col}" }

      unless qubit_val
        j = i + ((1 << target_bit) * 2)
        Rails.logger.debug { "i, j = #{i}, #{j}" }

        xr = @state_vector[i / 2].real
        xi = @state_vector[i / 2].imag
        yr = @state_vector[j / 2].real
        yi = @state_vector[j / 2].imag

        Rails.logger.debug { "xr = #{xr}, xi = #{xi}" }
        Rails.logger.debug { "yr = #{yr}, yi = #{yi}" }

        @state_vector[i / 2] = Complex((xr * ar) - (xi * ai) + (yr * br) - (yi * bi),
                                       (xr * ai) + (xi * ar) + (yr * bi) + (yi * br))
        @state_vector[j / 2] =
          Complex((xr * cr) - (xi * ci) + (yr * dr) - (yi * di), (xr * ci) + (xi * cr) + (yr * di) + (yi * dr))
      end

      i += 2
    end

    # for (let r = 0; r < h; r++) {
    #   const isControlled = ((controlMask & r) ^ desiredValueMask) !== 0
    #   const qubit_val = (r & (1 << qubitIndex)) !== 0
    #   for (let c = 0; c < w; c++) {
    #     if (!isControlled && !qubit_val) {
    #       const j = i + (1 << qubitIndex) * 2 * w
    #       const xr = buf[i]
    #       const xi = buf[i + 1]
    #       const yr = buf[j]
    #       const yi = buf[j + 1]

    #       buf[i] = xr * ar - xi * ai + yr * br - yi * bi
    #       buf[i + 1] = xr * ai + xi * ar + yr * bi + yi * br
    #       buf[j] = xr * cr - xi * ci + yr * dr - yi * di
    #       buf[j + 1] = xr * ci + xi * cr + yr * di + yi * dr
    #     }
    #     i += 2
    #   }
    # }

    @state_vector
  end
end
