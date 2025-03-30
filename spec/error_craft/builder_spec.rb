# frozen_string_literal: true

require "spec_helper"
require "error_craft/builder"

RSpec.describe ErrorCraft::Builder do
  context "when using an array format" do
    let(:builder) { ErrorCraft::Builder.new(format: :array) }

    it "adds errors correctly" do
      builder.add_error(:error1, %w[message1 message2])
      builder.add_error(:error2, "message3")
      builder.add_error(:error3, { error4: "message4" })

      expect(builder.build).to eq([
                                    { key: :error1, value: %w[message1 message2] },
                                    { key: :error2, value: ["message3"] },
                                    { key: :error3, value: [{ key: :error4, value: ["message4"] }] }
                                  ])
    end
  end

  context "when using a hash format" do
    let(:builder) { ErrorCraft::Builder.new(format: :hash) }

    it "adds errors correctly" do
      builder.add_error(:error1, %w[message1 message2])
      builder.add_error(:error2, "message3")
      builder.add_error(:error3, { error4: "message4" })

      expect(builder.build).to eq({
                                    error1: %w[message1 message2],
                                    error2: ["message3"],
                                    error3: { error4: ["message4"] }
                                  })
    end
  end

  context "when invalid error value" do
    let(:builder) { ErrorCraft::Builder.new }

    it "raises an error" do
      expect { builder.add_error(:error1, 123) }.to raise_error(ArgumentError)
    end
  end

  context "when invalid format" do
    let(:builder) { ErrorCraft::Builder.new(format: :invalid_format) }

    it "raises an error for unsupported formats" do
      expect { builder.add_error(:error1, "message", format: :unsupported) }.to raise_error(ArgumentError)
    end
  end
end
