# frozen_string_literal: true

module ErrorBuilder
  module Formats
    class Hash < Base
      def to_h
        errors.each_with_object({}) do |error, hash|
          keys = flat ? [error.key] : error.keys

          add_nested_key(hash, keys, error.message)
        end
      end

      private

      def add_nested_key(hash, keys, value)
        key = keys.shift

        if keys.empty?
          add_message(hash, key, value)
        else
          hash[key] ||= {}

          add_nested_key(hash[key], keys, value)
        end
      end

      def add_message(hash, key, value)
        if value.is_a?(::Array)
          hash[key] ||= []

          hash[key] += value
        else
          hash[key] = value
        end
      end
    end
  end
end
