# frozen_string_literal: true

require "rails_helper"

RSpec.describe Address do
  describe Address do
    let(:address) { described_class.new(address: build(:address).address) }

    it "validates the presence of a name" do
      address.address = ""
      expect(address.valid?).to be false
    end
  end

  describe "validations" do
    let(:address) { described_class.new(address: build(:address).address) }

    it "is valid with valid attributes" do
      expect(address.valid?).to be true
    end

    it "is not valid without an address" do
      address.address = nil
      expect(address.valid?).not_to be true
    end

    it "is not valid without a unique address" do
      address.save
      address2 = described_class.new(address: address.address)
      expect(address2.valid?).not_to be true
    end
  end

  describe "class methods" do
    it "returns all addresses" do
      expect(described_class.all.count).to eq(described_class.count)
    end
  end

  describe "associations" do
    it "has many start_addresses" do
      association = described_class.reflect_on_association(:start_addresses)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:class_name]).to eq("Ride")
      expect(association.options[:foreign_key]).to eq("start_address_id")
    end

    it "has many destination_addresses" do
      association = described_class.reflect_on_association(:destination_addresses)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:class_name]).to eq("Ride")
      expect(association.options[:foreign_key]).to eq("destination_address_id")
    end

    it "has many home_addresses" do
      association = described_class.reflect_on_association(:home_addresses)
      expect(association.macro).to eq(:has_many)
    end
  end
end
