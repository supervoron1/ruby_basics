# frozen_string_literal: true

require_relative 'modules/validation'

# Route class
class Route
  include Validation
  attr_reader :first_station, :last_station, :intermediate_stations
  validate :first_station, :type, Station
  validate :first_station, :format, Station::STATION_NAME_FORMAT
  validate :last_station, :type, Station
  validate :last_station, :format, Station::STATION_NAME_FORMAT


  FIRST_STATION_MISSING_ERROR = 'Не задана начальная станция! Попробуйте еще раз.'
  LAST_STATION_MISSING_ERROR = 'Не задана конечная станция! Попробуйте еще раз.'
  ROUTE_NAMING_ERROR = 'Начальная и конечная станции не должны быть одинаковыми.'

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    validate!
    @intermediate_stations = []
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
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

  protected

  def validate!
    raise FIRST_STATION_MISSING_ERROR if first_station.nil?
    raise LAST_STATION_MISSING_ERROR if last_station.nil?
    raise ROUTE_NAMING_ERROR if first_station == last_station
  end
end
