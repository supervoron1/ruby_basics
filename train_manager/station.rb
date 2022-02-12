# frozen_string_literal: true

require_relative 'modules/instance_counter'
# station class
class Station
  include InstanceCounter
  attr_accessor :trains
  attr_reader :name

  EMPTY_NAME_ERROR = 'Станции не присвоено имя'
  INVALID_NAME_ERROR = 'Слишком короткое имя станции. Должно быть не менее 3 символов'

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

  protected

  def validate!
    raise EMPTY_NAME_ERROR if name.empty?
    raise INVALID_NAME_ERROR if name.length < 3
  end
end
