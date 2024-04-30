# frozen_string_literal: true

require 'test_helper'

class CircuitsControllerTest < ActionDispatch::IntegrationTest
  test 'H ゲート 1 つの回路を計算' do
    get circuit_path, params: { circuit: { steps: ['H'] }, qubitCount: 1 }, as: :json

    amplitudes = JSON.parse(@response.body)

    assert_equal 2, amplitudes.length
    assert_equal 1 / Math.sqrt(2), amplitudes[0]['real']
    assert_equal 0, amplitudes[0]['imag']
    assert_equal 1 / Math.sqrt(2), amplitudes[1]['real']
    assert_equal 0, amplitudes[1]['imag']
  end
end
