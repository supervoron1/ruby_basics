# frozen_string_literal: true

class Train
  attr_reader :number, :wagons, :speed, :route

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @current_station_index = 0
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

  def add_wagon
    return unless @speed.zero?

    @wagons += 1
  end

  def remove_wagon
    @wagons -= 1 if @wagons.positive? && @speed.zero?
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
