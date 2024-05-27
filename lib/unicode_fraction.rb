# frozen_string_literal: true

# '½', '⅔' などの Unicode で書ける分数を表すクラス。
# Matrix とそのまま掛け算などを計算できるようにするために、
# Numeric クラスを継承する。
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

  attr_writer :string

  def self.from_string(string)
    fraction_string = '0' if string == '0'
    UnicodeFraction::ALL.each do |each|
      fraction_string = each.fetch(:unicode) if each.fetch(:unicode) == string
      fraction_string = each.fetch(:unicode) if each[:expanded] == string
      fraction_string = "√#{each.fetch(:unicode)}" if "√#{each.fetch(:unicode)}" == string
    end

    return unless fraction_string

    fraction = new
    fraction.string = fraction_string
    fraction
  end

  def self.from_number(number, epsilon = 0.0005)
    fraction = new

    if number.abs < epsilon
      fraction.string = '0'
      return fraction
    end

    unicode_fraction = find_unicode_fraction do |each|
      (each.fetch(:value) - number).abs <= epsilon
    end
    if unicode_fraction&.fetch(:unicode)
      fraction.string = unicode_fraction.fetch(:unicode)
      return fraction
    end

    unicode_fraction = find_unicode_fraction do |each|
      (Math.sqrt(each.fetch(:value)) - number).abs <= epsilon
    end
    if unicode_fraction&.fetch(:unicode)
      fraction.string = "√#{unicode_fraction.fetch(:unicode)}"
      return fraction
    end

    nil
  end

  def self.find(&block)
    ALL.each do |each|
      next unless block.yield(each.fetch(:value))

      fraction = new
      fraction.string = each[:unicode]
      return fraction
    end

    nil
  end

  def self.find_unicode_fraction(&block)
    ALL.each do |each|
      return each if block.yield(each)
    end

    nil
  end

  # def self.match_unicode_fraction(&block)
  #   ALL.each do |each|
  #     return each if block.yield(each)
  #   end

  #   nil
  # end

  def to_s
    @string
  end

  def to_f
    fraction = UnicodeFraction.find_unicode_fraction do |each|
      each.fetch(:unicode) == @string
    end
    return fraction.fetch(:value) if fraction

    fraction = UnicodeFraction.find_unicode_fraction do |each|
      "√#{each.fetch(:unicode)}" == @string
    end
    return Math.sqrt(fraction.fetch(:value)) if fraction

    raise "unknown fraction: #{@string}"
  end
end

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
