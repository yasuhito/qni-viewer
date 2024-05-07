# frozen_string_literal: true

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

# Complex クラスに #to_h を追加
module CoreExt::HumanReadableComplex
  def to_h
    return abbreviate_float(real) if imag.abs <= 0.0005

    if real.abs <= 0.0005
      return 'i' if (imag - 1).abs <= 0.0005
      return '-i' if (imag + 1).abs <= 0.0005

      return "#{abbreviate_float(imag)}i"
    end

    to_h_both_values(epsilon)
  end

  private

  def abbreviate_float(number, epsilon = 0.0005)
    return '0' if number.abs < epsilon
    return "-#{abbreviate_float(-number, epsilon)}" if number < 0

    fraction = match_unicode_fraction do |each|
      (each.fetch(:value) - number).abs <= epsilon
    end
    return fraction.fetch(:character) if fraction

    root_fraction = match_unicode_fraction do |each|
      (Math.sqrt(each.fetch(:value)) - number).abs <= epsilon
    end
    return "√#{root_fraction.fetch(:character)}" if root_fraction

    number.to_s
  end

  def to_h_both_values(epsilon)
    separator = imag >= 0 ? '+' : '-'
    imag_factor = (imag.abs - 1).abs <= epsilon ? '' : abbreviate_float(imag.abs)
    prefix = real < 0 ? '' : '+'

    "#{prefix + abbreviate_float(real) + separator + imag_factor}i"
  end

  def match_unicode_fraction(&block)
    UNICODE_FRACTIONS.each do |each|
      return each if block.yield(each)
    end

    nil
  end
end
