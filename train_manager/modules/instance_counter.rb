# frozen_string_literal: true

# Instance counter
module InstanceCounter
  @instances = 0

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # class_methods
  module ClassMethods
    attr_writer :instances

    def instances
      @instances ||= 0
    end
  end

  # instance_methods
  module InstanceMethods
    protected

    def register_instance
      self.class.instances += 1
    end
  end
end
