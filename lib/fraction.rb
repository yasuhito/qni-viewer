# frozen_string_literal: true

# 分数を表すクラス
class Fraction < Numeric
  attr_writer :string

  def self.from_string(string)
    fraction = new
    fraction.string = string
    fraction
  end

  def to_s
    @string
  end

  def to_f
    {
      '½' => 1.0 / 2,
      '√½' => Math.sqrt(1.0 / 2)
    }.fetch(@string)
  end
end

# rubocop:disable Naming/MethodName
def Fraction(string)
  Fraction.from_string(string)
end
# rubocop:enable Naming/MethodName
