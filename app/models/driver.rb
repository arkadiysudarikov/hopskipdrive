class Driver < ApplicationRecord
  belongs_to :home_address, class_name: "Address"
end
