# frozen_string_literal: true

# Description: This module is used to get the upcoming rides from the database.
module UpcomingRides
  class DirectionAPIError < StandardError; end

  METERS_IN_A_MILE = 1609.34
  SECONDS_IN_A_MINUTE = 60

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

    Rails.cache.fetch(cache_key, expires_in: 5.minutes) do # Look to see if can call fetch_all
      response = call_api(start_address.address, destination_address.address) # call_directions_api

      process_response(response)
    end
  end

  # The call_api method takes in the start and destination addresses and returns the response from
  # the Google Maps Directions API. It uses the url method to get the URL for the Google Maps
  # Directions API.
  # It uses the open method to open the URL and the read method to read the response.
  # It uses the JSON.parse method to parse the response and return it.
  # The call_api method is used by the get_directions method to get the commute distance and
  # duration and the ride distance and duration.
  # The call_api method is also used by the process_response method to process the response.
  def call_api(origin, destination)
    JSON.parse(URI.parse(url(origin, destination)).open.read) # look into failure mode
  rescue URI::Error
    raise DirectionAPIError, "Unable to fetch directions. Please try again."
  end

  # The URL is the Google Maps Directions API URL. It takes in the start and destination addresses
  def url(origin, destination)
    "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{destination}&key=#{Rails.application.credentials.google_api_key}"
  end

  # The process_response method takes in the response from the Google Maps Directions API and
  # processes it. It returns the distance and duration of the route in miles and minutes
  # respectively.
  def process_response(response)
    check_response(response)

    route = response["routes"].first["legs"].first

    [route["distance"]["value"].to_f / METERS_IN_A_MILE, # Convert meters to miles
     route["duration"]["value"].to_f / SECONDS_IN_A_MINUTE] # Convert seconds to minutes
  end

  # The check_response method takes in the response from the Google Maps Directions API and checks
  # if it is OK. If it is not OK, it raises a DirectionAPIError with the error message from the
  # response.
  # If there is no response from the Google Maps API, it raises a DirectionAPIError with the
  # message "No response from Google Maps API".
  # The check_response method is used by the process_response method to process the response.
  def check_response(response)
    raise DirectionAPIError, "Not OK" unless response["status"] == "OK"
    raise DirectionAPIError, "Google Directioons API error" if response["error_message"].present?
  end

  # The add_ride_attributes method takes in a driver and a ride and returns a new hash with the
  # ride's attributes and additional attributes such as the driver's home address, the commute
  # distance and duration, the ride distance and duration, the ride earnings, and the score.
  def add_ride_attributes(driver, ride)
    # Rename data (to ride_data?) - testable
    data = data(driver.home_address, ride.start_address, ride.destination_address)

    ride.attributes.merge(data)
  end

  # Add unit tests
  def ride_earnings(ride_distance, ride_duration)
    # The ride earnings is how much the driver earns by driving the ride. It takes into account
    # both the amount of time the ride is expected to take and the distance. For the purposes of
    # this exercise, it is calculated as:
    # $12 + $1.50 per mile beyond 5 miles + (ride duration) * $0.70 per minute beyond 15 minutes

    12 + ([ride_distance - 5, 0].max * 1.5) + ([ride_duration - 15, 0].max * 0.7)
  end

  # The score is a metric that takes into account the ride earnings, the commute duration, and the
  # ride duration. It is calculated as the ride earnings divided by the sum of the commute duration
  # and the ride duration.
  # Add unit test
  def score(ride_earnings, commute_duration, ride_duration)
    ride_earnings / (commute_duration + ride_duration)
  end

  # The data method takes in the driver's home address, the start address, and the destination
  # address, and returns a hash with the commute distance and duration, the ride distance and
  # duration, the ride earnings, and the score.
  # It uses the get_directions method to get the commute distance and duration and the ride distance
  # and duration, and the ride_earnings method to get the ride earnings.
  # It uses the score method to get the score.
  # It returns the hash with the data.
  # The data method is used by the add_ride_attributes method to add the ride's attributes and
  # additional attributes to the ride.
  # The data method is also used by the upcoming_rides method to get the upcoming rides from the
  # database.
  # The data method is also used by the add_ride_attributes method to add the ride's attributes and
  # additional attributes to the ride.
  def data(home_address, start_address, destination_address)
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
