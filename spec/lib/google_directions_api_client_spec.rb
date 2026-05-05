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

    it "returns deterministic fake directions in development when no API key is available" do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("development"))

      fake_client = described_class.new(nil)

      expect(fake_client.get_directions("1588 E Thompson Blvd", "2112 E Thompson Blvd")).to eq(
        fake_client.get_directions("1588 E Thompson Blvd", "2112 E Thompson Blvd")
      )
    end

    it "returns deterministic fake directions when fake mode is enabled" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("GOOGLE_DIRECTIONS_MODE").and_return("fake")

      result = google_directions_api_client.get_directions("1588 E Thompson Blvd", "2112 E Thompson Blvd")

      expect(result).to all(be > 0)
    end
  end
end
