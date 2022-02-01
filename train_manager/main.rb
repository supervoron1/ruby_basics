# frozen_string_literal: true

require_relative 'train'
require_relative 'station'
require_relative 'route'

class Main
  def start
    puts 'Hooked up all in one file'
  end
end

rr = Main.new
rr.start
