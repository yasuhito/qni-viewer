# frozen_string_literal: true

# '½', '⅔' などの Unicode で書ける分数を表すクラス。
# Matrix とそのまま掛け算などを計算できるようにするために、Numeric クラスを継承する。
class UnicodeFraction < Numeric
  ALL = [
    { unicode: '½', expanded: '1/2', value: 1.0 / 2 },
    { unicode: '⅓', expanded: '1/3', value: 1.0 / 3 },
    { unicode: '⅔', expanded: '2/3', value: 2.0 / 3 },
    { unicode: '¼', expanded: '1/4', value: 1.0 / 4 },
    { unicode: '¾', expanded: '3/4', value: 3.0 / 4 },
    { unicode: '⅕', expanded: '1/5', value: 1.0 / 5 },
    { unicode: '⅖', expanded: '2/5', value: 2.0 / 5 },
    { unicode: '⅗', expanded: '3/5', value: 3.0 / 5 },
    { unicode: '⅘', expanded: '4/5', value: 4.0 / 5 },
    { unicode: '⅙', expanded: '1/6', value: 1.0 / 6 },
    { unicode: '⅚', expanded: '5/6', value: 5.0 / 6 },
    { unicode: '⅐', expanded: '1/7', value: 1.0 / 7 },
    { unicode: '⅛', expanded: '1/8', value: 1.0 / 8 },
    { unicode: '⅜', expanded: '3/8', value: 3.0 / 8 },
    { unicode: '⅝', expanded: '5/8', value: 5.0 / 8 },
    { unicode: '⅞', expanded: '7/8', value: 7.0 / 8 },
    { unicode: '⅑', expanded: '1/9', value: 1.0 / 9 },
    { unicode: '⅒', expanded: '1/10', value: 1.0 / 10 }
  ].freeze

  attr_writer :string, :value

  def self.from_string(string)
    fraction_string = '0' if string == '0'
    fraction_value = nil

    UnicodeFraction::ALL.each do |each|
      if each.fetch(:unicode) == string
        fraction_string = each.fetch(:unicode)
        fraction_value = each.fetch(:value)
      end
      if each[:expanded] == string
        fraction_string = each.fetch(:unicode)
        fraction_value = each.fetch(:value)
      end
      if "√#{each.fetch(:unicode)}" == string
        fraction_string = "√#{each.fetch(:unicode)}"
        fraction_value = Math.sqrt(each.fetch(:value))
      end
    end

    return unless fraction_string

    create(fraction_string, fraction_value)
  end

  def self.from_number(number, epsilon = 0.0005)
    return create('0', 0) if number.abs < epsilon

    unicode_fraction = find_unicode_fraction do |each|
      (each.fetch(:value) - number).abs <= epsilon
    end
    return create(unicode_fraction.fetch(:unicode), unicode_fraction.fetch(:value)) if unicode_fraction&.fetch(:unicode)

    unicode_fraction = find_unicode_fraction do |each|
      (Math.sqrt(each.fetch(:value)) - number).abs <= epsilon
    end
    if unicode_fraction&.fetch(:unicode)
      return create("√#{unicode_fraction.fetch(:unicode)}", Math.sqrt(unicode_fraction.fetch(:value)))
    end

    nil
  end

  def self.find_unicode_fraction(&block)
    ALL.each do |each|
      return each if block.yield(each)
    end

    nil
  end

  def self.create(string, value)
    fraction = new
    fraction.string = string
    fraction.value = value
    fraction
  end

  def +(other)
    @value + other
  end

  def -(other)
    @value - other
  end

  def *(other)
    @value * other
  end

  def /(other)
    @value / other
  end

  def <=>(other)
    @value <=> other
  end

  def to_wolfram
    @string
  end

  def to_f
    @value
  end
end

# rubocop:disable Style/Documentation
module Kernel
  # rubocop:disable Naming/MethodName
  def UnicodeFraction(value, epsilon = nil)
    case value
    when String
      # epsilon が指定されていたらエラー
      raise ArgumentError, 'invalid argument: epsilon' if epsilon

      UnicodeFraction.from_string(value)
    when Numeric
      if epsilon
        UnicodeFraction.from_number(value, epsilon)
      else
        UnicodeFraction.from_number(value)
      end
    else
      raise ArgumentError, "invalid argument: #{value}"
    end
  end
  # rubocop:enable Naming/MethodName
end
# rubocop:enable Style/Documentation
