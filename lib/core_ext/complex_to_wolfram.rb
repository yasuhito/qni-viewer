# frozen_string_literal: true

require 'unicode_fraction'

module CoreExt
  # Complex クラスに #to_wolfram を追加
  module ComplexToWolfram
    def to_wolfram(epsilon = 0.0005)
      return abbreviate_float(real, epsilon) if imag.abs <= epsilon

      if real.abs <= epsilon
        return 'i' if (imag - 1).abs <= epsilon
        return '-i' if (imag + 1).abs <= epsilon

        return "#{abbreviate_float(imag, epsilon)}i"
      end

      to_wolfram_both_values(epsilon)
    end

    private

    def abbreviate_float(number, epsilon)
      return '0' if number.abs < epsilon
      return "-#{abbreviate_float(-number, epsilon)}" if number.negative?

      fraction = UnicodeFraction(number, epsilon)
      return fraction.to_wolfram if fraction

      number.to_s
    end

    def to_wolfram_both_values(epsilon)
      separator = imag >= 0 ? '+' : '-'
      imag_factor = (imag.abs - 1).abs <= epsilon ? '' : abbreviate_float(imag.abs, epsilon)

      "#{abbreviate_float(real, epsilon) + separator + imag_factor}i"
    end
  end
end
