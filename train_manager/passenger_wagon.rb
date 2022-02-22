# frozen_string_literal: true

# passengerWagon class definition
class PassengerWagon < Wagon
  def initialize(number, capacity)
    super(number, capacity)
    @type = :passenger
  end

  def take_volume
    super(1)
  end

  alias take_seat take_volume
end
