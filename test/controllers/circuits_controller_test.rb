# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/complex'

class CircuitsControllerTest < ActionDispatch::IntegrationTest
  test 'H(0) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [["H"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 2, amplitudes.length
    assert_equal '√½', amplitudes[0].to_h
    assert_equal '√½', amplitudes[1].to_h
  end

  test 'H(1) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [[1, "H"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 4, amplitudes.length
    assert_equal '√½', amplitudes[0].to_h
    assert_equal '0', amplitudes[1].to_h
    assert_equal '√½', amplitudes[2].to_h
    assert_equal '0', amplitudes[3].to_h
  end

  test 'H(1, 2) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [["H", "H"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 4, amplitudes.length
    assert_equal '½', amplitudes[0].to_h
    assert_equal '½', amplitudes[1].to_h
    assert_equal '½', amplitudes[2].to_h
    assert_equal '½', amplitudes[3].to_h
  end

  test 'X(0) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [["X"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 2, amplitudes.length
    assert_equal '0', amplitudes[0].to_h
    assert_equal '1', amplitudes[1].to_h
  end

  test 'X(1) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [[1, "X"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 4, amplitudes.length
    assert_equal '0', amplitudes[0].to_h
    assert_equal '0', amplitudes[1].to_h
    assert_equal '1', amplitudes[2].to_h
    assert_equal '0', amplitudes[3].to_h
  end

  test 'X(1, 2) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [["X", "X"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 4, amplitudes.length
    assert_equal '0', amplitudes[0].to_h
    assert_equal '0', amplitudes[1].to_h
    assert_equal '0', amplitudes[2].to_h
    assert_equal '1', amplitudes[3].to_h
  end

  test 'Y(0) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [["Y"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 2, amplitudes.length
    assert_equal '0', amplitudes[0].to_h
    assert_equal 'i', amplitudes[1].to_h
  end

  test 'Y(1) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [[1, "Y"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 4, amplitudes.length
    assert_equal '0', amplitudes[0].to_h
    assert_equal '0', amplitudes[1].to_h
    assert_equal 'i', amplitudes[2].to_h
    assert_equal '0', amplitudes[3].to_h
  end

  test 'Y(1, 2) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [["Y", "Y"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 4, amplitudes.length
    assert_equal '0', amplitudes[0].to_h
    assert_equal '0', amplitudes[1].to_h
    assert_equal '0', amplitudes[2].to_h
    assert_equal '-1', amplitudes[3].to_h
  end

  test 'Z(0) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [["Z"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 2, amplitudes.length
    assert_equal '1', amplitudes[0].to_h
    assert_equal '0', amplitudes[1].to_h
  end

  test 'Z(1) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [[1, "Z"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 4, amplitudes.length
    assert_equal '1', amplitudes[0].to_h
    assert_equal '0', amplitudes[1].to_h
    assert_equal '0', amplitudes[2].to_h
    assert_equal '0', amplitudes[3].to_h
  end

  test 'Z(1, 2) 回路を計算' do
    get circuit_path, params: { circuit_json: '{ "cols": [["Z", "Z"]] }' }, as: :json

    amplitudes = JSON.parse(@response.body).map do |each|
      Complex(each['real'], each['imag'])
    end

    assert_equal 4, amplitudes.length
    assert_equal '1', amplitudes[0].to_h
    assert_equal '0', amplitudes[1].to_h
    assert_equal '0', amplitudes[2].to_h
    assert_equal '0', amplitudes[3].to_h
  end
end
