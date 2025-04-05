# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

module ErrorBuilder
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.included(base)
    base.include(InstanceMethods)
  end

  module InstanceMethods
    def errors
      @errors ||= Engine.new
    end
  end
end
