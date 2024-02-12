class Address < ApplicationRecord
  has_many :home_addresses, class_name: "Driver", foreign_key: "home_address_id"
  has_many :start_addresses, class_name: "Ride", foreign_key: "start_address_id"
  has_many :destination_addresses, class_name: "Ride", foreign_key: "destination_address_id"

  validates :address, uniqueness: true
end
