# frozen_string_literal: true

# Driver model is used to store the driver's address.
class Driver < ApplicationRecord
  belongs_to :home_address, class_name: "Address"
end
