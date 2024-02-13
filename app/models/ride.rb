class Ride < ApplicationRecord
  belongs_to :start_address, class_name: "Address"
  belongs_to :destination_address, class_name: "Address"

  def self.upcoming_rides
    Ride.eager_load(:start_address, :destination_address).all
  end
end
