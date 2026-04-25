# frozen_string_literal: true

require "rails_helper"

RSpec.describe GoogleDirectionsApiClient do
  subject(:google_directions_api_client) do
    described_class.new("GOOGLE_DIRECTIONS_API_KEY")
  end

  let(:headers) do
    {
      "Accept" => "*/*",
      "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
      "User-Agent" => "Ruby"
    }
  end

  describe '#get_directions' do
    it 'returns the distance and duration in miles and hours' do
      stub_request(:get, "https://maps.googleapis.com/maps/api/directions/json?origin=1588%20E%20Thompson%20Blvd&destination=2112%20E%20Thompson%20Blvd&key=GOOGLE_DIRECTIONS_API_KEY")
        .with(
          headers: headers
        )
        .to_return(status: 200, body: '{
        "routes" :
        [
           {
              "legs" :
              [
                 {
                    "distance" :
                    {
                       "value" : 8046.7
                    },
                    "duration" :
                    {
                       "value" : 36000
                    }
                 }
              ]
           }
        ],
        "status" : "OK"
        }', headers: {})

      # Expect the get_directions method to return the distance and duration in miles and hours
      expect(google_directions_api_client.get_directions("1588 E Thompson Blvd",
                                                         "2112 E Thompson Blvd")).to eq([5.0, 10.0])
    end

    it 'raises a friendly error when the request times out' do
      allow(URI).to receive(:parse).and_call_original
      allow(URI).to receive(:parse)
        .with("https://maps.googleapis.com/maps/api/directions/json?origin=1588+E+Thompson+Blvd&destination=2112+E+Thompson+Blvd&key=GOOGLE_DIRECTIONS_API_KEY")
        .and_return(instance_double(URI::HTTPS).tap do |uri|
          allow(uri).to receive(:open).and_raise(Timeout::Error)
        end)

      expect do
        google_directions_api_client.get_directions("1588 E Thompson Blvd", "2112 E Thompson Blvd")
      end.to raise_error(DirectionsAPIError, "Unable to fetch directions. Please try again.")
    end

    it 'raises a directions error when the response does not include route legs' do
      stub_request(:get, "https://maps.googleapis.com/maps/api/directions/json?origin=1588%20E%20Thompson%20Blvd&destination=2112%20E%20Thompson%20Blvd&key=GOOGLE_DIRECTIONS_API_KEY")
        .with(
          headers: headers
        )
        .to_return(status: 200, body: '{
        "routes" : [],
        "status" : "OK"
        }', headers: {})

      expect do
        google_directions_api_client.get_directions("1588 E Thompson Blvd", "2112 E Thompson Blvd")
      end.to raise_error(DirectionsAPIError, GoogleDirectionsApiClient::GOOGLE_DIRECTIONS_API_ERROR)
    end
  end
end
