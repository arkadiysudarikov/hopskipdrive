# frozen_string_literal: true

# A ride has a start address and a destination address.
class Ride < ApplicationRecord
  belongs_to :start_address, class_name: "Address"
  belongs_to :destination_address, class_name: "Address"

  validates_comparison_of :destination_address, other_than: :start_address
end
