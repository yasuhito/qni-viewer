# frozen_string_literal: true

require 'test_helper'
require 'core_ext/complex'

def _(string)
  Dentaku.evaluate string
end

class CircuitsControllerTest < ActionDispatch::IntegrationTest
  test 'ゲートなし 1 qubit の回路を計算' do
    get circuit_path, params: { qubit_count: 1 }, as: :json

    amplitudes = JSON.parse(@response.body)

    assert_equal 2, amplitudes.length
    assert_equal 1, amplitudes[0]['real']
    assert_equal 0, amplitudes[0]['imag']
    assert_equal 0, amplitudes[1]['real']
    assert_equal 0, amplitudes[1]['imag']
  end

  test 'ゲートなし 2 qubit の回路を計算' do
    get circuit_path, params: { qubit_count: 2 }, as: :json

    amplitudes = JSON.parse(@response.body)

    assert_equal 4, amplitudes.length
    assert_equal 1, amplitudes[0]['real']
    assert_equal 0, amplitudes[0]['imag']
    assert_equal 0, amplitudes[1]['real']
    assert_equal 0, amplitudes[1]['imag']
    assert_equal 0, amplitudes[2]['real']
    assert_equal 0, amplitudes[2]['imag']
    assert_equal 0, amplitudes[3]['real']
    assert_equal 0, amplitudes[3]['imag']
  end

  test 'ゲートなし 3 qubit の回路を計算' do
    get circuit_path, params: { qubit_count: 3 }, as: :json

    amplitudes = JSON.parse(@response.body)

    assert_equal 8, amplitudes.length
    assert_equal 1, amplitudes[0]['real']
    assert_equal 0, amplitudes[0]['imag']
    assert_equal 0, amplitudes[1]['real']
    assert_equal 0, amplitudes[1]['imag']
    assert_equal 0, amplitudes[2]['real']
    assert_equal 0, amplitudes[2]['imag']
    assert_equal 0, amplitudes[3]['real']
    assert_equal 0, amplitudes[3]['imag']
    assert_equal 0, amplitudes[4]['real']
    assert_equal 0, amplitudes[4]['imag']
    assert_equal 0, amplitudes[5]['real']
    assert_equal 0, amplitudes[5]['imag']
    assert_equal 0, amplitudes[6]['real']
    assert_equal 0, amplitudes[6]['imag']
    assert_equal 0, amplitudes[7]['real']
    assert_equal 0, amplitudes[7]['imag']
  end

  test 'H(0) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [["H"]] }', qubit_count: 1 }, as: :json

    amplitudes = JSON.parse(@response.body)

    assert_equal 2, amplitudes.length
    assert_in_delta _('1 / SQRT(2)'), amplitudes[0]['real']
    assert_equal 0, amplitudes[0]['imag']
    assert_in_delta _('1 / SQRT(2)'), amplitudes[1]['real']
    assert_equal 0, amplitudes[1]['imag']
  end

  test 'H(1) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [["I", "H"]] }', qubit_count: 2 }, as: :json

    amplitudes = JSON.parse(@response.body)

    assert_equal 4, amplitudes.length
    assert_in_delta _('1 / SQRT(2)'), amplitudes[0]['real']
    assert_equal 0, amplitudes[0]['imag']
    assert_equal 0, amplitudes[1]['real']
    assert_equal 0, amplitudes[1]['imag']
    assert_in_delta _('1 / SQRT(2)'), amplitudes[2]['real']
    assert_equal 0, amplitudes[2]['imag']
    assert_equal 0, amplitudes[3]['real']
    assert_equal 0, amplitudes[3]['imag']
  end

  test 'H(1, 2) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [["H", "H"]] }', qubit_count: 2 }, as: :json

    amplitudes = JSON.parse(@response.body)

    assert_equal 4, amplitudes.length
    assert_in_delta _('1 / SQRT(4)'), amplitudes[0]['real']
    assert_equal 0, amplitudes[0]['imag']
    assert_in_delta _('1 / SQRT(4)'), amplitudes[1]['real']
    assert_equal 0, amplitudes[1]['imag']
    assert_in_delta _('1 / SQRT(4)'), amplitudes[2]['real']
    assert_equal 0, amplitudes[2]['imag']
    assert_in_delta _('1 / SQRT(4)'), amplitudes[3]['real']
    assert_equal 0, amplitudes[3]['imag']
  end

  test '1/2 → ½' do
    assert_equal '½', Complex(1.0 / 2).to_h
  end

  test '1/4 → ¼' do
    assert_equal '¼', Complex(1.0 / 4).to_h
  end

  test '3/4 → ¾' do
    assert_equal '¾', Complex(3.0 / 4).to_h
  end

  test '1/3 → ⅓' do
    assert_equal '⅓', Complex(1.0 / 3).to_h
  end

  test '2/3 → ⅔' do
    assert_equal '⅔', Complex(2.0 / 3).to_h
  end

  test '1/5 → ⅕' do
    assert_equal '⅕', Complex(1.0 / 5).to_h
  end

  test '2/5 → ⅖' do
    assert_equal '⅖', Complex(2.0 / 5).to_h
  end

  test '3/5 → ⅗' do
    assert_equal '⅗', Complex(3.0 / 5).to_h
  end

  test '4/5 → ⅘' do
    assert_equal '⅘', Complex(4.0 / 5).to_h
  end

  test '1/6 → ⅙' do
    assert_equal '⅙', Complex(1.0 / 6).to_h
  end

  test '5/6 → ⅚' do
    assert_equal '⅚', Complex(5.0 / 6).to_h
  end

  test '1/7 → ⅐' do
    assert_equal '⅐', Complex(1.0 / 7).to_h
  end

  test '1/8 → ⅛' do
    assert_equal '⅛', Complex(1.0 / 8).to_h
  end

  test '3/8 → ⅜' do
    assert_equal '⅜', Complex(3.0 / 8).to_h
  end

  test '5/8 → ⅝' do
    assert_equal '⅝', Complex(5.0 / 8).to_h
  end

  test '7/8 → ⅞' do
    assert_equal '⅞', Complex(7.0 / 8).to_h
  end

  test '1/9 → ⅑' do
    assert_equal '⅑', Complex(1.0 / 9).to_h
  end

  test '1/10 → ⅒' do
    assert_equal '⅒', Complex(1.0 / 10).to_h
  end

  test 'Math.sqrt(1/2) → √½' do
    assert_equal '√½', Math.sqrt(Complex(1.0 / 2)).to_h
  end

  test 'Math.sqrt(3/4) → √¾' do
    assert_equal '√¾', Math.sqrt(Complex(3.0 / 4)).to_h
  end

  test 'Math.sqrt(1/3) → √⅓' do
    assert_equal '√⅓', Math.sqrt(Complex(1.0 / 3)).to_h
  end

  test 'Math.sqrt(2/3) → √⅔' do
    assert_equal '√⅔', Math.sqrt(Complex(2.0 / 3)).to_h
  end

  test 'Math.sqrt(1/5) → √⅕' do
    assert_equal '√⅕', Math.sqrt(Complex(1.0 / 5)).to_h
  end

  test 'Math.sqrt(2/5) → √⅖' do
    assert_equal '√⅖', Math.sqrt(Complex(2.0 / 5)).to_h
  end

  test 'Math.sqrt(3/5) → √⅗' do
    assert_equal '√⅗', Math.sqrt(Complex(3.0 / 5)).to_h
  end

  test 'Math.sqrt(4/5) → √⅘' do
    assert_equal '√⅘', Math.sqrt(Complex(4.0 / 5)).to_h
  end

  test 'Math.sqrt(1/6) → √⅙' do
    assert_equal '√⅙', Math.sqrt(Complex(1.0 / 6)).to_h
  end

  test 'Math.sqrt(5/6) → √⅚' do
    assert_equal '√⅚', Math.sqrt(Complex(5.0 / 6)).to_h
  end

  test 'Math.sqrt(1/7) → √⅐' do
    assert_equal '√⅐', Math.sqrt(Complex(1.0 / 7)).to_h
  end

  test 'Math.sqrt(1/8) → √⅛' do
    assert_equal '√⅛', Math.sqrt(Complex(1.0 / 8)).to_h
  end

  test 'Math.sqrt(3/8) → √⅜' do
    assert_equal '√⅜', Math.sqrt(Complex(3.0 / 8)).to_h
  end

  test 'Math.sqrt(5/8) → √⅝' do
    assert_equal '√⅝', Math.sqrt(Complex(5.0 / 8)).to_h
  end

  test 'Math.sqrt(7/8) → √⅞' do
    assert_equal '√⅞', Math.sqrt(Complex(7.0 / 8)).to_h
  end

  test 'Math.sqrt(1/10) → √⅒' do
    assert_equal '√⅒', Math.sqrt(Complex(1.0 / 10)).to_h
  end
end
