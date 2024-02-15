# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ride do
  describe "associations" do
    it "belongs to start_address" do
      association = described_class.reflect_on_association(:start_address)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq("Address")
    end

    it "belongs to destination_address" do
      association = described_class.reflect_on_association(:destination_address)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq("Address")
    end
  end

  describe "validations" do
    let(:ride) do
      described_class.new(start_address: build(:address), destination_address: build(:address))
    end

    it "is valid with valid attributes" do
      expect(ride.valid?).to be true
    end

    it "is not valid without a start_address" do
      ride.start_address = nil
      expect(ride.valid?).not_to be true
    end

    it "is not valid without a destination_address" do
      ride.destination_address = nil
      expect(ride.valid?).not_to be true
    end

    it "is not valid if the destination_address is the same as the start_address" do
      ride.destination_address = ride.start_address
      expect(ride.valid?).not_to be true
    end
  end
end
