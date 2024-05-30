#!/usr/bin/env ruby
# frozen_string_literal: true

require 'benchmark'
require 'ruby-prof'
require 'test_helper'

class SimulatorTest < ActiveSupport::TestCase
  class PerformanceTest < ActiveSupport::TestCase
    test '|00..0> * HH...H' do
      simulator = Simulator.new('0' * 16)

      # StackProf.run(out: '/tmp/stackprof.dump') do
      #   10.times do
      #     0.upto(15) do |each|
      #       simulator.h(each)
      #     end
      #   end
      # end

      # result = RubyProf::Profile.profile do
      #   10.times do
      #     0.upto(15) do |each|
      #       simulator.h(each)
      #     end
      #   end
      # end
      # printer = RubyProf::GraphPrinter.new(result)
      # printer.print($stdout, {})

      # start_time = Time.now.to_f
      # 10.times do
      #   0.upto(15) do |each|
      #     simulator.h(each)
      #   end
      # end
      # end_time = Time.now.to_f

      # puts "elapsed time = #{end_time - start_time}"
    end
  end
end
