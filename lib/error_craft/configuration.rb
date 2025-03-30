# frozen_string_literal: true

module ErrorCraft
  class Configuration
    attr_accessor :default_format

    def initialize
      @default_format = :hash
    end
  end
end
