# frozen_string_literal: true

module ErrorBuilder
  class FormatResolver
    attr_reader :format

    def initialize(format)
      @format = format
    end

    def formatter
      return built_in_formatter unless format.is_a?(Class)

      format
    end

    def built_in_formatter
      case format
      when :array
        Formats::Array
      when :hash
        Formats::Hash
      else
        raise ArgumentError, "Unsupported format: #{format}"
      end
    end
  end
end
