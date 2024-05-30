#!/usr/bin/env ruby -Ilib

require 'simulator'
require 'stackprof'

simulator = Simulator.new('0' * 16)

StackProf.run(out: '/tmp/stackprof.dump') do
  10.times do
    0.upto(15) do |each|
      simulator.h(each)
    end
  end
end
