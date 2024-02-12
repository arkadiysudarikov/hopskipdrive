class Ride < ApplicationRecord
  belongs_to :start_address, class_name: "Address"
  belongs_to :destination_address, class_name: "Address"
end
