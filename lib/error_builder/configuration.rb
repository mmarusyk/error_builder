# frozen_string_literal: true

module ErrorBuilder
  class Configuration
    attr_accessor :format, :message_format

    def initialize
      @format         = :hash
      @message_format = :array
    end
  end
end
