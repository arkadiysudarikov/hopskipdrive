# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

["1588 E Thomspon Blvd",
 "1600 Pennsylvania Ave",
 "1600 Amphitheatre Pkwy",
 "2112 E Thompson Blvd"].each do |address|
  Address.find_or_create_by!(address: address)
end

Driver.find_or_create_by!(id: "e76885d9-dc50-4616-830e-cd24beefd7d9",
                          home_address: Address.all.sample)

Ride.find_or_create_by(start_address: Address.first, destination_address: Address.second)
Ride.find_or_create_by(start_address: Address.first, destination_address: Address.third)
Ride.find_or_create_by(start_address: Address.first, destination_address: Address.fourth)

Ride.find_or_create_by(start_address: Address.second, destination_address: Address.first)
Ride.find_or_create_by(start_address: Address.second, destination_address: Address.third)
Ride.find_or_create_by(start_address: Address.second, destination_address: Address.fourth)

Ride.find_or_create_by(start_address: Address.third, destination_address: Address.first)
Ride.find_or_create_by(start_address: Address.third, destination_address: Address.second)
Ride.find_or_create_by(start_address: Address.third, destination_address: Address.fourth)

Ride.find_or_create_by(start_address: Address.fourth, destination_address: Address.first)
Ride.find_or_create_by(start_address: Address.fourth, destination_address: Address.second)
Ride.find_or_create_by(start_address: Address.fourth, destination_address: Address.third)
