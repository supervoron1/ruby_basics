# frozen_string_literal: true

require_relative 'modules/manufacturer'

class Wagon
  include Manufacturer

  attr_reader :type
end
