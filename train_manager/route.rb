# frozen_string_literal: true

class Route
  attr_reader :first_station, :last_station, :intermediate_stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @intermediate_stations = []
  end

  def add_station(station)
    return if @intermediate_stations.include?(station)

    @intermediate_stations << station
  end

  def remove_station(station)
    @intermediate_stations.delete(station)
  end

  # using `splat` operator to expand array @intermediate_stations
  def stations
    [@first_station, *@intermediate_stations, @last_station]
  end
end
