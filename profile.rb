#!/usr/bin/env ruby -Ilib

require 'ruby-prof'
require 'simulator'

simulator = Simulator.new('0' * 16)

result = RubyProf::Profile.profile do
  10.times do
    0.upto(15) do |each|
      simulator.h(each)
    end
  end
end
printer = RubyProf::GraphPrinter.new(result)
printer.print($stdout, {})
