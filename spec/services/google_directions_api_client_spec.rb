# frozen_string_literal: true

require "rails_helper"

RSpec.describe GoogleDirectionsApiClient do
  subject(:google_directions_api_client) do
    described_class.new(Rails.application.credentials.google_api_key)
  end

  let(:headers) do
    {
      "Accept" => "*/*",
      "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
      "User-Agent" => "Ruby"
    }
  end

  describe '#get_directions' do
    it 'returns the distance and duration in miles and minutes' do
      stub_request(:get, "https://maps.googleapis.com/maps/api/directions/json?origin=1588%20E%20Thompson%20Blvd&destination=2112%20E%20Thompson%20Blvd&key=#{Rails.application.credentials.google_api_key}")
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
                       "text" : "0.5 mi",
                       "value" : 8046.7
                    },
                    "duration" :
                    {
                       "text" : "1 min",
                       "value" : 600
                    }
                 }
              ]
           }
        ],
        "status" : "OK"
        }', headers: {})

      # Expect the get_directions method to return the distance and duration in miles and minutes
      expect(google_directions_api_client.get_directions("1588 E Thompson Blvd",
                                                         "2112 E Thompson Blvd")).to eq([5.0, 10.0])
    end
  end
end
