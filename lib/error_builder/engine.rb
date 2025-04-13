# frozen_string_literal: true

module ErrorBuilder
  class Engine
    attr_reader :format, :errors

    def initialize(format: ErrorBuilder.configuration.format)
      @format = format
      @errors = []
    end

    def add(key, message)
      error = ErrorBuilder::Error.new(key)
      error.add_message(message)

      @errors << error
    end

    def to_h(flat: false)
      formatter.new(errors, flat:).to_h
    end

    def formatter
      FormatResolver.new(format).formatter
    end
  end
end
