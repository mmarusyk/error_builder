# frozen_string_literal: true

RSpec.describe ErrorBuilder do
  it "has a version number" do
    expect(subject::VERSION).not_to be_nil
  end

  it "has a configuration" do
    expect(subject.configuration).to be_a(ErrorBuilder::Configuration)
  end

  it "can be configured" do
    expect do
      subject.configure do |config|
        config.format = :new_format
        config.message_format = :new_message_format
      end
    end.to change { subject.configuration.format }.to(:new_format)
       .and change { subject.configuration.message_format }.to(:new_message_format)
  end

  it "includes InstanceMethods in the class" do
    expect(subject.included(Class.new).included_modules).to include(ErrorBuilder::InstanceMethods)
  end
end
