# frozen_string_literal: true

module ErrorBuilder
  module Formats
    class Base
      attr_reader :errors, :flat

      def initialize(errors, flat:)
        @errors = errors
        @flat   = flat
      end

      def to_h
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end
