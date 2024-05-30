#!/usr/bin/env ruby -Ilib

require "benchmark"
require "simulator"

simulator = Simulator.new('0' * 16)

Benchmark.bm(5) do |r|
  r.report("H*16") do
    10.times do
      0.upto(15) do |each|
        simulator.h(each)
      end
    end
  end
end
