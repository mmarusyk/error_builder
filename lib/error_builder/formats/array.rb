# frozen_string_literal: true

module ErrorBuilder
  module Formats
    class Array < Base
      def to_h
        errors.each_with_object([]) do |error, array|
          keys = flat ? [error.key] : error.keys

          build_nested_error(array, keys, error.message)
        end
      end

      private

      def build_nested_error(array, keys, value)
        key = keys.shift

        if keys.empty?
          array << [key, value]
        else
          nested_array = find_or_create_nested_array(array, key)

          build_nested_error(nested_array, keys, value)
        end
      end

      def find_or_create_nested_array(array, key)
        existing = array.find { |e| e.is_a?(::Array) && e.first == key }

        if existing
          existing[1]
        else
          new_array = [key, []]
          array << new_array
          new_array[1]
        end
      end
    end
  end
end
