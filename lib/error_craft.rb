# frozen_string_literal: true

require_relative "error_craft/version"
require_relative "error_craft/configuration"
require_relative "error_craft/builder"

module ErrorCraft
  class Error < StandardError; end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
