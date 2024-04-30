require "simulator"

class CircuitsController < ApplicationController
  def show
    @simulator = Simulator.new('0' * params['qubitCount'].to_i)
  end
end
