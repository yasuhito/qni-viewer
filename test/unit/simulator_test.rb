#!/usr/bin/env ruby
# frozen_string_literal: true

require 'test_helper'
require 'ruby-prof'

class SimulatorTest < ActiveSupport::TestCase
  class PerformanceTest < ActiveSupport::TestCase
    test '|00..0> * HH...H' do
      simulator = Simulator.new('0' * 16)

      result = RubyProf::Profile.profile do
        0.upto(15) do |each|
          simulator.h(each)
        end
      end
      printer = RubyProf::GraphPrinter.new(result)
      printer.print($stdout, {})
    end
  end
end
