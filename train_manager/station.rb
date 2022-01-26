# frozen_string_literal: true

class Station
  attr_accessor :trains
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
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
