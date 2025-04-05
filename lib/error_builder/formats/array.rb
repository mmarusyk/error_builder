# frozen_string_literal: true

module ErrorBuilder
  module Formats
    class Array < Base
      def to_h
        formatted = errors.map do |error|
          build_nested_error(error.keys, error.message)
        end

        { errors: formatted }
      end

      private

      def build_nested_error(keys, value)
        key = keys.shift

        if keys.empty?
          [{ key: key.to_sym, value: value }]
        else
          [{ key: key.to_sym, value: build_nested_error(keys, value) }]
        end
      end
    end
  end
end
