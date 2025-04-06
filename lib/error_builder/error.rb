# frozen_string_literal: true

module ErrorBuilder
  class Error
    attr_reader :key, :message, :format

    def initialize(key)
      @key     = key
      @format  = ErrorBuilder.configuration.message_format
      @message = initialize_message(format)
    end

    def add_message(message)
      case format
      when :array
        @message << message
      when :string
        @message = message
      else
        raise ArgumentError, "Unsupported message format: #{format}"
      end
    end

    def to_h
      {
        key: @key,
        message: @message
      }
    end

    def keys
      return [key] unless key.to_s.include?(".")

      deflat_key
    end

    private

    def initialize_message(format)
      case format
      when :array
        []
      when :string
        ""
      else
        raise ArgumentError, "Unsupported message format: #{format}"
      end
    end

    def deflat_key
      key
        .to_s
        .split(".")
        .flat_map { |part| part.split(/[\[\]]+/) }
        .reject(&:empty?)
        .map { |part| parse_part(part) }
    end

    def parse_part(part)
      if integer?(part)
        part.to_i
      else
        key.is_a?(String) ? part : part.to_sym
      end
    end

    def integer?(part)
      part.match?(/\A\d+\z/)
    end
  end
end
