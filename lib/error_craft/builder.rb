# frozen_string_literal: true

module ErrorCraft
  class Builder
    SUPPORTED_FORMATS = {
      array: -> { [] },
      hash: -> { {} }
    }.freeze

    def initialize(format: [])
      @format = format || ErrorCraft.configuration.default_format
      @errors = initialize_errors(@format)
    end

    def add_error(key, value)
      formatted_value = format_value(value)

      add_to_errors(key, formatted_value)
    end

    def build
      @errors
    end

    private

    def initialize_errors(format)
      SUPPORTED_FORMATS.fetch(format) { raise ArgumentError, "Unsupported format: #{format}" }.call
    end

    def format_value(value)
      case value
      when Array then value
      when String then [value]
      when Hash then format_hash(value)
      else
        raise ArgumentError, "Invalid error value. Must be a string, array, or hash."
      end
    end

    def format_hash(value)
      value.transform_values { |v| format_value(v) }.then do |formatted_hash|
        @format == :array ? hash_to_array(formatted_hash) : formatted_hash
      end
    end

    def hash_to_array(hash)
      hash.map { |k, v| { key: k, value: v } }
    end

    def add_to_errors(key, value)
      case @errors
      when Array then @errors << { key: key, value: value }
      when Hash then @errors[key] = value
      end
    end
  end
end
