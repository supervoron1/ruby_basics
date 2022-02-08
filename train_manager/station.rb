# frozen_string_literal: true

require_relative 'modules/instance_counter'
# station class
class Station
  include InstanceCounter
  attr_accessor :trains
  attr_reader :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
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
end
