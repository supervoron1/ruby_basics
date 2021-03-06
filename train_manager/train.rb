# frozen_string_literal: true

require_relative 'modules/manufacturer'
require_relative 'modules/instance_counter'

# Train class
class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :wagons, :speed, :route

  TRAIN_NUM_FORMAT = /^[0-9a-zа-я]{3}-?[0-9a-zа-я]{2}$/i.freeze
  TRAIN_NUM_FORMAT_ERROR = 'Номер поезда введен в неверном формате (999-AA).'

  @@trains = {}

  class << self
    def find(number)
      @@trains[number]
    end

    def all
      @@trains
    end
  end

  def initialize(number)
    @number = number
    validate!
    @wagons = []
    @speed = 0
    @current_station_index = 0
    @@trains[number] = self
    register_instance
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def speed_up(speed)
    @speed += speed
  end

  def slow_down(speed)
    @speed -= speed
    @speed = 0 if @speed.negative?
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    return unless @speed.zero?
    return unless attachable_wagon?(wagon)

    @wagons << wagon
  end

  def remove_wagon(wagon)
    return unless @speed.zero?

    @wagons.delete(wagon)
  end

  def route=(route)
    @route = route
    @current_station_index = 0
    current_station.accept_train(self)
  end

  def current_station
    @route.stations[@current_station_index]
  end

  def move_next_station
    return if last_station?

    current_station.send_train(self)
    next_station.accept_train(self)
    @current_station_index += 1
  end

  def move_prev_station
    return if first_station?

    current_station.send_train(self)
    prev_station.accept_train(self)
    @current_station_index -= 1
  end

  def each_wagon(&block)
    @wagons.each(&block) if block_given?
  end

  protected

  def validate!
    raise TRAIN_NUM_FORMAT_ERROR if number !~ TRAIN_NUM_FORMAT
  end

  def next_station
    @route.stations[@current_station_index + 1]
  end

  def prev_station
    return unless @current_station_index.positive?

    @route.stations[@current_station_index - 1]
  end

  def last_station?
    @current_station_index == @route.stations.size - 1
  end

  def first_station?
    @current_station_index.zero?
  end
end
