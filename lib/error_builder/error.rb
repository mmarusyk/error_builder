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
      [key] if key.is_a?(Symbol)

      key.to_s.delete(":").split(".")
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
  end
end
