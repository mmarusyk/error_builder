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
      case format
      when :array
        Formats::Array.new(@errors, flat:).to_h
      when :hash
        Formats::Hash.new(@errors, flat:).to_h
      else
        raise ArgumentError, "Unsupported format: #{format}"
      end
    end
  end
end
