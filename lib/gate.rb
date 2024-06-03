# frozen_string_literal: true

require 'matrix'
require 'unicode_fraction'

# 量子ゲート
class Gate
  def self.i
    Complex::I
  end

  def self.e
    Math::E
  end

  def self.phase(radian)
    Matrix[[1, 0],
           [0, e**(i * radian)]]
  end

  # TODO: StateVector::Matrix クラスを使う
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
end
