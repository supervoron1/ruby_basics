# frozen_string_literal: true

class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    super
    @type = :passenger
  end

  def attachable_wagon?(wagon)
    wagon.is_a?(PassengerWagon)
  end
end
