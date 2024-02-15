# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    address { Faker::Address.street_address }
  end
end
