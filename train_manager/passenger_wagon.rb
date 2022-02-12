# frozen_string_literal: true

class PassengerWagon < Wagon
  def initialize(number, capacity)
    super(number, capacity)
    @type = :passenger
  end

  def take_volume
    super(1)
  end
end
