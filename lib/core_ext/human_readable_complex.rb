# frozen_string_literal: true

module CoreExt
  # Complex クラスに #to_h を追加
  module HumanReadableComplex
    def to_wolfram(epsilon = 0.0005)
      return abbreviate_float(real) if imag.abs <= epsilon

      if real.abs <= epsilon
        return 'i' if (imag - 1).abs <= epsilon
        return '-i' if (imag + 1).abs <= epsilon

        return "#{abbreviate_float(imag, epsilon)}i"
      end

      to_h_both_values(epsilon)
    end

    private

    def abbreviate_float(number, epsilon = 0.0005)
      return '0' if number.abs < epsilon
      return "-#{abbreviate_float(-number, epsilon)}" if number.negative?

      fraction = UnicodeFraction(number, epsilon)
      return fraction.to_s if fraction

      root_fraction = UnicodeFraction(number, epsilon)
      return root_fraction.to_h if root_fraction

      number.to_s
    end

    def to_h_both_values(epsilon)
      separator = imag >= 0 ? '+' : '-'
      imag_factor = (imag.abs - 1).abs <= epsilon ? '' : abbreviate_float(imag.abs)
      prefix = real.negative? ? '' : '+'

      "#{prefix + abbreviate_float(real) + separator + imag_factor}i"
    end
  end
end
