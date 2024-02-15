# frozen_string_literal: true

class DirectionsAPIError < StandardError; end

class GoogleDirectionsApiClient
  BASE_URL = "https://maps.googleapis.com/maps/api/directions/json"

  METERS_IN_A_MILE = 1609.34
  SECONDS_IN_A_MINUTE = 60

  def initialize(api_key)
    @api_key = api_key
  end

  def get_directions(origin, destination)
    url = build_url(origin, destination)

    response = send_request(url)

    check_response(response)

    parse_response(response)
  end

  private

  def build_url(origin, destination)
    "#{BASE_URL}?origin=#{URI.encode_www_form_component(origin)}&destination=#{URI.encode_www_form_component(destination)}&key=#{@api_key}"
  end

  def send_request(url)
    JSON.parse(URI.parse(url).open.read)
  rescue URI::Error
    raise DirectionsAPIError, "Unable to fetch directions. Please try again."
  end

  def check_response(response)
    raise DirectionsAPIError, "Not OK" unless response["status"] == "OK"
    raise DirectionsAPIError, "Google Directioons API error" if response["error_message"].present?
  end

  def parse_response(response)
    route = response["routes"].first["legs"].first

    [route["distance"]["value"].to_f / METERS_IN_A_MILE, # Convert meters to miles
     route["duration"]["value"].to_f / SECONDS_IN_A_MINUTE] # Convert seconds to minutes
  end
end
