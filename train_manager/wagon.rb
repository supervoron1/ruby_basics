# frozen_string_literal: true

require_relative 'modules/manufacturer'
# require_relative 'modules/validation'

class Wagon
  include Manufacturer
  # include Validation

  WAGON_CAPACITY_ERROR = 'Не задан объем вагона!'
  WAGON_NUMBER_ERROR = 'Номер вагона введен в неверном формате (99-999).'
  WAGON_NUM_FORMAT = /^[0-9]{2}-?[0-9]{3}$/i.freeze

  attr_accessor :capacity, :taken_volume
  attr_reader :number, :type

  # validate :number, :format, WAGON_NUM_FORMAT

  def initialize(number, capacity)
    @number = number
    @capacity = capacity
    validate!
    @taken_volume = 0
  end

  def take_volume(volume)
    @taken_volume += volume
  end

  def free_volume
    @capacity - @taken_volume
  end

  def free_volume?
    free_volume.positive?
  end

  protected

  def validate!
    raise WAGON_NUMBER_ERROR if number !~ WAGON_NUM_FORMAT
    raise WAGON_CAPACITY_ERROR if capacity <= 0
  end
end
