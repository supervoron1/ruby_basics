# frozen_string_literal: true

class Route
  attr_reader :first_station, :last_station, :stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = []
  end

  def add_station(station)
    return if @stations.include?(station)

    @stations << station
  end

  def remove_station(station)
    @stations.delete(station)
  end

  # using `splat` operator to expand array @stations
  def show
    [@first_station, *@stations, @last_station]
  end
end
