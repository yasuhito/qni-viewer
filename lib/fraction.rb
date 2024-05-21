# frozen_string_literal: true

# Unicode でも表せる分数を表すクラス。
# Matrix とそのまま掛け算などを計算できるようにするために、
# Numeric クラスを継承する。
class Fraction < Numeric
  UNICODE_FRACTIONS = [
    { character: '½', value: 1.0 / 2 },
    { character: '¼', value: 1.0 / 4 },
    { character: '¾', value: 3.0 / 4 },
    { character: '⅓', value: 1.0 / 3 },
    { character: '⅔', value: 2.0 / 3 },
    { character: '⅕', value: 1.0 / 5 },
    { character: '⅖', value: 2.0 / 5 },
    { character: '⅗', value: 3.0 / 5 },
    { character: '⅘', value: 4.0 / 5 },
    { character: '⅙', value: 1.0 / 6 },
    { character: '⅚', value: 5.0 / 6 },
    { character: '⅐', value: 1.0 / 7 },
    { character: '⅛', value: 1.0 / 8 },
    { character: '⅜', value: 3.0 / 8 },
    { character: '⅝', value: 5.0 / 8 },
    { character: '⅞', value: 7.0 / 8 },
    { character: '⅑', value: 1.0 / 9 },
    { character: '⅒', value: 1.0 / 10 }
  ].freeze

  attr_writer :string

  def self.from_string(string)
    fraction = new
    fraction.string = string
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
    if unicode_fraction&.fetch(:character)
      fraction.string = unicode_fraction.fetch(:character)
      return fraction
    end

    unicode_fraction = find_unicode_fraction do |each|
      (Math.sqrt(each.fetch(:value)) - number).abs <= epsilon
    end
    if unicode_fraction&.fetch(:character)
      fraction.string = "√#{unicode_fraction.fetch(:character)}"
      return fraction
    end

    nil
  end

  def self.find_with_close_value(value, epsilon = 0.0005)
    unicode_fraction = Fraction.find_unicode_fraction do |each|
      (each.fetch(:value) - value).abs <= epsilon
    end
    return unless unicode_fraction

    fraction = new
    fraction.string = unicode_fraction[:character]
    fraction
  end

  def self.find(&block)
    UNICODE_FRACTIONS.each do |each|
      next unless block.yield(each.fetch(:value))

      fraction = new
      fraction.string = each[:character]
      return fraction
    end

    nil
  end

  def self.find_unicode_fraction(&block)
    UNICODE_FRACTIONS.each do |each|
      return each if block.yield(each)
    end

    nil
  end

  # def self.match_unicode_fraction(&block)
  #   UNICODE_FRACTIONS.each do |each|
  #     return each if block.yield(each)
  #   end

  #   nil
  # end

  def to_s
    @string
  end

  def to_f
    fraction = Fraction.find_unicode_fraction do |each|
      each.fetch(:character) == @string
    end
    return fraction.fetch(:value) if fraction

    fraction = Fraction.find_unicode_fraction do |each|
      "√#{each.fetch(:character)}" == @string
    end
    return Math.sqrt(fraction.fetch(:value)) if fraction

    raise "unknown fraction: #{@string}"
  end
end

# rubocop:disable Naming/MethodName
def Fraction(string)
  Fraction.from_string(string)
end
# rubocop:enable Naming/MethodName
