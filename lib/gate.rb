# frozen_string_literal: true

require 'complex_matrix'
require 'state_vector'
require 'unicode_fraction'

# 量子ゲート
class Gate
  def self.i
    Complex::I
  end

  def self.e
    Math::E
  end

  H = ComplexMatrix[[1, 1],
                    [1, -1]] * UnicodeFraction('√½')
  X = ComplexMatrix[[0, 1],
                    [1, 0]]
  Y = ComplexMatrix[[0, -i],
                    [i, 0]]
  Z = ComplexMatrix[[1, 0],
                    [0, -1]]
  RNOT = ComplexMatrix[[i + 1, -i + 1],
                       [-i + 1, i + 1]] * UnicodeFraction('½')

  def self.rx(theta)
    ComplexMatrix[[Math.cos(theta / 2), -i * Math.sin(theta / 2)],
                  [-i * Math.sin(theta / 2), Math.cos(theta / 2)]]
  end

  def self.ry(theta)
    ComplexMatrix[[Math.cos(theta / 2), -Math.sin(theta / 2)],
                  [Math.sin(theta / 2), Math.cos(theta / 2)]]
  end

  def self.rz(theta)
    ComplexMatrix[[e**(-i * theta / 2), 0],
                  [0, e**(i * theta / 2)]]
  end

  def self.phase(radian)
    ComplexMatrix[[1, 0],
                  [0, e**(i * radian)]]
  end
end
