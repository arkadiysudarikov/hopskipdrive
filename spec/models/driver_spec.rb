# frozen_string_literal: true

require "rails_helper"

RSpec.describe Driver do
  describe "associations" do
    it "belongs to address" do
      association = described_class.reflect_on_association(:home_address)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
