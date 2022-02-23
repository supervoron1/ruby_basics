# frozen_string_literal: true

# cargoWagon class definition
class CargoWagon < Wagon
  # @validators = []

  def initialize(number, capacity)
    super(number, capacity)
    @type = :cargo
  end
end
