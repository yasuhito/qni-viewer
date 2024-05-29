#!/usr/bin/env ruby
# frozen_string_literal: true

require 'test_helper'
require 'ruby-prof'

class SimulatorTest
  class PerformanceTest < ActiveSupport::TestCase
    test '|00..0> * HH...H' do
      Simulator.new('0' * 16)

      # result = RubyProf::Profile.profile do
      #   0.upto(15) do |each|
      #     simulator.h(each)
      #   end
      # end
      # printer = RubyProf::GraphPrinter.new(result)
      # printer.print(STDOUT, {})

      # StackProf.run(out: '/tmp/stackprof.dump') do
      #   simulator.h(0)
      #   # 10.times do
      #   #   0.upto(15) do |each|
      #   #     simulator.h(each)
      #   #   end
      #   # end
      # end
    end
  end
end
