# frozen_string_literal: true

require 'test_helper'

class CircuitsControllerTest < ActionDispatch::IntegrationTest
  test 'ゲートなし 1 qubit の回路を計算' do
    get circuit_path, params: { qubitCount: 1 }, as: :json

    amplitudes = JSON.parse(@response.body)

    assert_equal 2, amplitudes.length
    assert_equal 1, amplitudes[0]['real']
    assert_equal 0, amplitudes[0]['imag']
    assert_equal 0, amplitudes[1]['real']
    assert_equal 0, amplitudes[1]['imag']
  end

  test 'ゲートなし 2 qubit の回路を計算' do
    get circuit_path, params: { qubitCount: 2 }, as: :json

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
    get circuit_path, params: { qubitCount: 3 }, as: :json

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

  # test 'H ゲート 1 つの回路を計算' do
  #   get circuit_path, params: { circuit: { steps: ['H'] }, qubitCount: 1 }, as: :json

  #   amplitudes = JSON.parse(@response.body)

  #   assert_equal 2, amplitudes.length
  #   assert_equal 1 / Math.sqrt(2), amplitudes[0]['real']
  #   assert_equal 0, amplitudes[0]['imag']
  #   assert_equal 1 / Math.sqrt(2), amplitudes[1]['real']
  #   assert_equal 0, amplitudes[1]['imag']
  # end
end
