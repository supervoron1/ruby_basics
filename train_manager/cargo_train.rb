# frozen_string_literal: true

class CargoTrain < Train
  attr_reader :type

  def initialize(number)
    super
    @type = :cargo
  end

  def attachable_wagon?(wagon)
    wagon.is_a?(CargoWagon)
  end
end
