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
end
