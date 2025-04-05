# frozen_string_literal: true

module ErrorBuilder
  module Formats
    class Hash < Base
      def to_h
        formatted = errors.each_with_object({}) do |error, hash|
          set_nested_key(hash, error.keys, error.message)
        end

        { errors: formatted }
      end

      private

      def set_nested_key(hash, keys, value)
        key = keys.shift

        if keys.empty?
          hash[key.to_sym] = value
        else
          hash[key.to_sym] ||= {}

          set_nested_key(hash[key.to_sym], keys, value)
        end
      end
    end
  end
end
