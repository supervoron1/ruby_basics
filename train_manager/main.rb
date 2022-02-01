# frozen_string_literal: true

require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'cargo_train'
require_relative 'passenger_train'

class Main
  def start
    puts 'Hooked up all in one file'
  end
end

rr = Main.new
rr.start
