# frozen_string_literal: true

require "rails_helper"

RSpec.describe Driver do
  describe "associations" do
    it "belongs to address" do
      association = described_class.reflect_on_association(:home_address)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    let(:driver) { described_class.new(home_address: build(:address)) }

    it "is valid with valid attributes" do
      expect(driver.valid?).to be true
    end

    it "is not valid without a home_address" do
      driver.home_address = nil
      expect(driver.valid?).not_to be true
    end
  end
end
