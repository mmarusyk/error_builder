# frozen_string_literal: true

module ErrorBuilder
  module Formats
    class Base
      attr_reader :errors

      def initialize(errors)
        @errors = errors
      end

      def to_h
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end
