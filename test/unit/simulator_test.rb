#!/usr/bin/env ruby
# frozen_string_literal: true

require 'test_helper'

class SimulatorTest
  class PerformanceTest < ActiveSupport::TestCase
    test '|00..0> * HH...H' do
      simulator = Simulator.new('0' * 16)

      10.times do
        0.upto(15) do |each|
          simulator.h(each)
        end
      end
    end
  end
end
