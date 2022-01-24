# frozen_string_literal: true

class Driver
  attr_reader :name, :cars

  def initialize(name)
    @name = name
    @cars = []
  end

  def buy_car(car)
    @cars << car
    car.change_door_title(self)
  end
end
