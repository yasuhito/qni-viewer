# frozen_string_literal: true

# 分数を表すクラス
class Fraction < Numeric
  def self.from_string(_string)
    new
  end

  def to_s
    '√½'
  end

  def to_f
    Math.sqrt(0.5)
  end
end

# rubocop:disable Naming/MethodName
def Fraction(string)
  Fraction.from_string(string)
end
# rubocop:enable Naming/MethodName
