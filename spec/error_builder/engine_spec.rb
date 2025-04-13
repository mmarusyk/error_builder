# frozen_string_literal: true

require "spec_helper"

RSpec.describe ErrorBuilder::Engine do
  describe "#initialize" do
    context "when no format passed" do
      it "initializes with default format" do
        expect(subject.format).to eq(ErrorBuilder.configuration.format)
      end
    end

    context "when format passed" do
      subject { described_class.new(format: format) }

      let(:format) { :array }

      it "initializes with a custom format" do
        expect(subject.format).to eq(format)
      end
    end
  end

  describe "#add" do
    let(:key) { :base }
    let(:message) { "Something went wrong" }

    before do
      subject.add(key, message)
    end

    shared_examples "error addition" do
      it "adds error with key" do
        expect(subject.errors.first.key).to eq(key)
      end

      it "adds error with message" do
        expect(subject.errors.first.message).to contain_exactly(message)
      end
    end

    context "when key is string" do
      let(:key) { "base" }

      include_examples "error addition"
    end

    context "when key is symbol" do
      let(:key) { :base }

      include_examples "error addition"
    end

    context "when key is nil" do
      let(:key) { nil }

      include_examples "error addition"
    end

    context "when message is string" do
      let(:message) { "Something went wrong" }

      include_examples "error addition"
    end

    context "when message is symbol" do
      let(:message) { :something_went_wrong }

      include_examples "error addition"
    end

    context "when message is nil" do
      let(:message) { nil }

      include_examples "error addition"
    end
  end

  describe "#to_h" do
    subject { described_class.new(format: format) }

    context "with simple errors" do
      before do
        subject.add(:base, "Something went wrong")
        subject.add(:base, "Something went wrong")
      end

      context "when format is array" do
        let(:format) { :array }

        it "returns array obj" do
          expect(subject.to_h).to be_an(Array)
        end

        it "returns errors in array" do
          expect(subject.to_h).to all(be_a(Array))
        end

        it "returns errors with keys" do
          expect(subject.to_h.map(&:first)).to all(eq(:base))
        end

        it "returns errors with message" do
          expect(subject.to_h.map(&:last)).to all(contain_exactly("Something went wrong"))
        end
      end

      context "when format is hash" do
        let(:format) { :hash }

        it "returns errors in hash format" do
          expect(subject.to_h).to be_a(Hash)
        end

        it "returns errors with unique keys" do
          expect(subject.to_h.keys).to match_array([:base])
        end

        it "returns error message in array" do
          expect(subject.to_h[:base]).to be_an(Array)
        end

        it "returns messages grouped by key" do
          expect(subject.to_h[:base]).to contain_exactly("Something went wrong", "Something went wrong")
        end
      end

      context "when format is unsupported" do
        let(:format) { :unsupported }

        it "raises ArgumentError" do
          expect { subject.to_h }.to raise_error(ArgumentError, /Unsupported format: unsupported/)
        end
      end

      context "when custom format" do
        let(:format) do
          Class.new do
            def initialize(errors, **)
              @errors = errors
            end

            def to_h
              @errors.map { |error| "#{error.key} #{error.message.join(", ")}" }
            end
          end
        end

        it "returns errors" do
          expect(subject.to_h).to contain_exactly("base Something went wrong", "base Something went wrong")
        end
      end
    end

    context "with nested keys" do
      before do
        subject.add(:"user.last_name", "can't be blank")
        subject.add(:"user.locations[0].name", "can't be blank")
        subject.add(:"user.locations[1].country", "can't be blank")
      end

      context "when format is array" do
        let(:format) { :array }
        let(:expected_result) do
          [[
            :user,
            [
              [:last_name, ["can't be blank"]],
              [
                :locations,
                [
                  [
                    0,
                    [
                      [
                        :name,
                        ["can't be blank"]
                      ]
                    ]
                  ],
                  [
                    1,
                    [
                      [
                        :country, ["can't be blank"]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]]
        end

        it "returns nested errors" do
          expect(subject.to_h).to eq(expected_result)
        end
      end

      context "when format is hash" do
        let(:format) { :hash }
        let(:expected_result) do
          {
            user: {
              last_name: ["can't be blank"],
              locations: {
                0 => {
                  name: ["can't be blank"]
                },
                1 => {
                  country: ["can't be blank"]
                }
              }
            }
          }
        end

        it "returns nested errors" do
          expect(subject.to_h).to eq(expected_result)
        end

        context "when flat is true" do
          let(:expected_result) do
            {
              "user.last_name": ["can't be blank"],
              "user.locations[0].name": ["can't be blank"],
              "user.locations[1].country": ["can't be blank"]
            }
          end

          it "returns flat errors" do
            expect(subject.to_h(flat: true)).to eq(expected_result)
          end
        end
      end
    end
  end
end
