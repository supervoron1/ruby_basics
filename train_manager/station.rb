# frozen_string_literal: true

require_relative 'modules/instance_counter'
require_relative 'modules/validation'
# station class
class Station
  include InstanceCounter
  include Validation
  attr_accessor :trains
  attr_reader :name

  STATION_NAME_FORMAT = /^\w{3,}$/i.freeze

  validate :name, :format, STATION_NAME_FORMAT
  validate :name, :type, String

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@stations << self
    register_instance
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def show_trains
    puts "Trains at #{name} station: "
    @trains.each { |train| puts "Train №#{train.number}, type: #{train.type}" }
  end

  def show_trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def list_trains(&block)
    @trains.each(&block)
  end

  def each_train(&block)
    # @trains.each(&block) if block_given?
    @trains.each.with_index(1, &block) if block_given?
  end

end
