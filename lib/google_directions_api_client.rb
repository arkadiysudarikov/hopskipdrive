# frozen_string_literal: true

# DirectionsAPIError is a custom error class that is raised when there is an error fetching
# directions from the Google Directions API
class DirectionsAPIError < StandardError; end

# GoogleDirectionsApiClient is a service class that fetches directions from the Google Directions
# API
class GoogleDirectionsApiClient
  # BASE_URL is the base URL for the Google Directions API
  BASE_URL = "https://maps.googleapis.com/maps/api/directions/json"

  # METERS_IN_A_MILE is the number of meters in a mile
  METERS_IN_A_MILE = 1_609.34
  # SECONDS_IN_AN_HOUR is the number of seconds in an hour
  SECONDS_IN_AN_HOUR = 3_600.0

  # GOOGLE_DIRECTIONS_API_ERROR is the error message when the Google Directions API returns an error
  GOOGLE_DIRECTIONS_API_ERROR = "Google Directions API Error"

  # api_key is the Google Directions API key
  def initialize(api_key)
    @api_key = api_key
  end

  # get_directions fetches directions from the Google Directions API
  def get_directions(origin, destination)
    return fake_directions(origin, destination) if fake_mode?

    url = build_url(origin, destination)

    response = send_request(url)

    check_response!(response)

    parse_response(response)
  end

  private

  def fake_mode?
    ENV["GOOGLE_DIRECTIONS_MODE"] == "fake" || (Rails.env.development? && @api_key.blank?)
  end

  def fake_directions(origin, destination)
    checksum = Zlib.crc32("#{origin}->#{destination}")
    miles = ((checksum % 2_000) / 100.0) + 1.0
    minutes = ((checksum / 2_000) % 180) + 10

    [miles.round(2), (minutes / 60.0).round(3)]
  end

  def build_url(origin, destination)
    "#{BASE_URL}?origin=#{URI.encode_www_form_component(origin)}&destination=#{URI.encode_www_form_component(destination)}&key=#{@api_key}"
  end

  def send_request(url)
    JSON.parse(URI.parse(url).open.read)
  rescue URI::Error, OpenURI::HTTPError, SocketError, IOError, SystemCallError, Timeout::Error, OpenSSL::SSL::SSLError, JSON::ParserError
    raise DirectionsAPIError, "Unable to fetch directions. Please try again."
  end

  def check_response!(response)
    raise DirectionsAPIError, GOOGLE_DIRECTIONS_API_ERROR unless response["status"] == "OK"
    raise DirectionsAPIError, GOOGLE_DIRECTIONS_API_ERROR if response["error_message"].present?
  end

  def parse_response(response)
    route = response["routes"].first["legs"].first

    [route["distance"]["value"].to_f / METERS_IN_A_MILE, # Convert meters to miles
     route["duration"]["value"].to_f / SECONDS_IN_AN_HOUR] # Convert seconds to hours
  end
end
