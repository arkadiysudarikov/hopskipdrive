# frozen_string_literal: true

# Description: This module is used to get the upcoming rides from the database.
module UpcomingRides
  # The CACHE_EXPIRATION constant is used to set the cache expiration time for the ride's
  # directions.
  CACHE_EXPIRATION = 5.0.minutes

  # The upcoming_rides method takes in a driver and returns the upcoming rides from the database.
  # It uses the Ride.where method to get the upcoming rides from the database.
  # It uses the map method to map the rides to a new array with the ride's attributes and additional
  # attributes such as the driver's home address, the commute distance and duration, the ride
  # distance and duration, the ride earnings, and the score.
  # It uses the add_ride_attributes method to add the ride's attributes and additional attributes to
  # the ride.
  # It uses the sort_by method to sort the rides by the score in descending order.
  # It returns the upcoming rides.
  # The upcoming_rides method is used by the drivers_controller to get the upcoming rides for a
  # driver.
  def upcoming_rides(driver, rides)
    upcoming_rides = rides.map do |ride|
      add_ride_attributes(driver, ride)
    end

    sort_upcoming_rides(upcoming_rides)
  end

  # The sort_upcoming_rides method takes in the upcoming rides and returns the upcoming rides sorted
  # by the score in descending order.
  def sort_upcoming_rides(upcoming_rides)
    upcoming_rides.sort_by { |ride| -ride[:score] }
  end

  # The get_directions method takes in the start and destination addresses and returns the commute
  # distance and duration and the ride distance and duration.
  # It uses the cache_key method to get the cache key for the ride's directions.
  # It returns the commute distance and duration and the ride distance and duration.
  # The get_directions method is used by the add_ride_attributes method to add the ride's attributes
  # and additional attributes to the ride.
  def get_directions(start_address, destination_address)
    cache_key = "ride/#{start_address.id}-#{destination_address.id}/directions"

    Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRATION) do
      # Consider dependency injection
      google_directions_api_client = GoogleDirectionsApiClient.new(
        Rails.application.credentials.google_api_key
      )

      google_directions_api_client.get_directions(start_address.address,
                                                  destination_address.address)
    end
  end

  # The add_ride_attributes method takes in a driver and a ride and returns a new hash with the
  # ride's attributes and additional attributes such as the driver's home address, the commute
  # distance and duration, the ride distance and duration, the ride earnings, and the score.
  def add_ride_attributes(driver, ride)
    data = get_data(driver.home_address, ride.start_address, ride.destination_address)

    ride.attributes.merge(data)
  end

  def ride_earnings(ride_distance, ride_duration)
    # The ride earnings is how much the driver earns by driving the ride. It takes into account
    # both the amount of time the ride is expected to take and the distance. For the purposes of
    # this exercise, it is calculated as:
    # $12 + $1.50 per mile beyond 5 miles + (ride duration) * $0.70 per minute beyond 15 minutes

    12.0 + ([ride_distance - 5.0, 0.0].max * 1.5) + ([ride_duration - 15.0, 0.0].max * 0.7)
  end

  # The score is a metric that takes into account the ride earnings, the commute duration, and the
  # ride duration. It is calculated as the ride earnings divided by the sum of the commute duration
  # and the ride duration.
  def score(ride_earnings, commute_duration, ride_duration)
    ride_earnings / (commute_duration + ride_duration)
  end

  # The get_data method takes in the driver's home address, the start address, and the destination
  # address, and returns a hash with the commute distance and duration, the ride distance and
  # duration, the ride earnings, and the score.
  # It uses the get_directions method to get the commute distance and duration and the ride distance
  # and duration, and the ride_earnings method to get the ride earnings.
  # It uses the score method to get the score.
  # It returns the hash with the data.
  # The get_data method is used by the add_ride_attributes method to add the ride's attributes and
  # additional attributes to the ride.
  # The get_data method is also used by the upcoming_rides method to get the upcoming rides from the
  # database.
  # The get_data method is also used by the add_ride_attributes method to add the ride's attributes
  # and additional attributes to the ride.
  def get_data(home_address, start_address, destination_address)
    commute_distance, commute_duration = get_directions(home_address, start_address)
    ride_distance, ride_duration = get_directions(start_address, destination_address)
    ride_earnings = ride_earnings(ride_distance, ride_duration)
    {
      home_address: home_address, start_address: start_address, commute_distance: commute_distance,
      commute_duration: commute_duration, destination_address: destination_address,
      ride_distance: ride_distance, ride_duration: ride_duration, ride_earnings: ride_earnings,
      score: score(ride_earnings, commute_duration, ride_duration)
    }
  end
end
