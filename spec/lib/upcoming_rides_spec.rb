# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpcomingRides do
  include described_class

  let(:driver) { instance_double(Driver, home_address: Faker::Address.street_address) }
  let(:ride) do
    instance_double(Ride, start_address: Faker::Address.street_address,
                          destination_address: Faker::Address.street_address)
  end

  let(:headers) do
    {
      "Accept" => "*/*",
      "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
      "User-Agent" => "Ruby"
    }
  end

  describe '#upcoming_rides' do
    it 'returns the upcoming rides' do
      # Create some sample rides
      ride1 = instance_double(Ride)
      ride2 = instance_double(Ride)
      ride3 = instance_double(Ride)

      # Stub the upcoming_rides method to return the sample rides
      allow(self).to receive(:upcoming_rides).and_return([ride1, ride2, ride3])

      # Expect the upcoming_rides method to return the rides
      expect(upcoming_rides(driver, ride)).to eq([ride1, ride2, ride3])
    end
  end

  describe '#sort_upcoming_rides' do
    it 'sorts the upcoming rides by the score in descending order' do
      # Create some sample rides with scores
      ride1 = { score: 5 }
      ride2 = { score: 7 }
      ride3 = { score: 3 }

      # Expect the sort_upcoming_rides method to return the rides sorted by score
      expect(sort_upcoming_rides([ride1, ride2, ride3])).to eq([ride2, ride1, ride3])
    end
  end

  describe '#get_directions' do
    it 'fetches directions from the cache if available' do
      # Stub the Rails.cache.fetch method to return the cached directions
      allow(Rails.cache).to receive(:fetch).and_return([5.0, 10.0])

      address1 = instance_double(Address, id: 1, address: "1588 E Thompson Blvd")
      address2 = instance_double(Address, id: 2, address: "2112 E Thompson Blvd")

      # Expect the directions method to return the cached directions
      expect(get_directions(address1, address2)).to eq([5.0, 10.0])
    end

    it 'calls the API and stores directions in the cache if not available' do
      # Stub the Rails.cache.fetch method to return nil (directions not in cache)
      allow(Rails.cache).to receive(:fetch).and_return(nil)

      stub_request(:get, "https://maps.googleapis.com/maps/api/directions/json?origin=1588 E Thompson Blvd&destination=2112 E Thompson Blvd&key=#{Rails.application.credentials.google_api_key}")
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

      address1 = instance_double(Address, id: 1, address: "1588 E Thompson Blvd")
      address2 = instance_double(Address, id: 2, address: "2112 E Thompson Blvd")

      # Expect the get_directions method to call the API and store the directions in the cache
      expect(Rails.cache).to receive(:fetch).with(anything, expires_in: 5.minutes).and_yield

      # Expect the get_directions method to return the fetched directions
      expect(get_directions(address1, address2)).to eq([5.0, 10.0])
    end
  end

  describe '#add_ride_attributes' do
    it 'returns a hash with ride attributes and additional attributes' do
      # Stub the get_data method to return sample data
      allow(self).to receive(:get_data).and_return({
                                                     home_address: '123 Main St',
                                                     start_address: '456 Elm St',
                                                     commute_distance: 5.0,
                                                     commute_duration: 10.0,
                                                     destination_address: '789 Oak St',
                                                     ride_distance: 8.0,
                                                     ride_duration: 15.0,
                                                     ride_earnings: 20.0,
                                                     score: 0.5
                                                   })

      # Stub the ride attributes to be merged
      allow(ride).to receive(:attributes).and_return({ id: 1, name: 'Ride 1' })

      # Expect the add_ride_attributes method to return a hash with merged attributes
      expect(add_ride_attributes(driver, ride)).to eq({
                                                        id: 1,
                                                        name: 'Ride 1',
                                                        home_address: '123 Main St',
                                                        start_address: '456 Elm St',
                                                        commute_distance: 5.0,
                                                        commute_duration: 10.0,
                                                        destination_address: '789 Oak St',
                                                        ride_distance: 8.0,
                                                        ride_duration: 15.0,
                                                        ride_earnings: 20.0,
                                                        score: 0.5
                                                      })
    end
  end

  describe '#ride_earnings' do
    it 'calculates the ride earnings based on ride distance and duration' do
      ride_distance = 10.0
      ride_duration = 20.0 / 60.0

      # Expect the ride_earnings method to calculate the earnings correctly
      expect(ride_earnings(ride_distance,
                           ride_duration)).to eq(12 + ((10.0 - 5.0) * 1.5) + ((20.0 - 15.0) * 0.7))
    end

    it 'calculates the ride earnings based on ride distance and duration' do
      ride_distance = 3.0
      ride_duration = 10.0 / 60.0

      # Expect the ride_earnings method to calculate the earnings correctly
      expect(ride_earnings(ride_distance, ride_duration)).to eq(12 + (0.0 * 1.5) + (0.0 * 0.7))
    end

    it 'calculates the ride earnings based on ride distance and duration' do
      ride_distance = 5.0
      ride_duration = 15.0 / 60.0

      # Expect the ride_earnings method to calculate the earnings correctly
      expect(ride_earnings(ride_distance, ride_duration)).to eq(12 + (0.0 * 1.5) + (0.0 * 0.7))
    end

    it 'calculates the ride earnings based on ride distance and duration' do
      ride_distance = 7.0
      ride_duration = 25.0 / 60.0

      # Expect the ride_earnings method to calculate the earnings correctly
      expect(ride_earnings(ride_distance,
                           ride_duration)).to eq(12 + ((7.0 - 5.0) * 1.5) + ((25.0 - 15.0) * 0.7))
    end

    it 'calculates the ride earnings based on ride distance and duration' do
      ride_distance = 1.0
      ride_duration = 5.0 / 60.0

      # Expect the ride_earnings method to calculate the earnings correctly
      expect(ride_earnings(ride_distance, ride_duration)).to eq(12 + (0.0 * 1.5) + (0.0 * 0.7))
    end

    it 'calculates the ride earnings based on ride distance and duration' do
      ride_distance = 10.0
      ride_duration = 15.0 / 60.0

      # Expect the ride_earnings method to calculate the earnings correctly
      expect(ride_earnings(ride_distance,
                           ride_duration)).to eq(12 + ((10.0 - 5.0) * 1.5) + (0.0 * 0.7))
    end

    it 'calculates the ride earnings based on ride distance and duration' do
      ride_distance = 10.0
      ride_duration = 10.0 / 60.0

      # Expect the ride_earnings method to calculate the earnings correctly
      expect(ride_earnings(ride_distance,
                           ride_duration)).to eq(12 + ((10.0 - 5.0) * 1.5) + (0.0 * 0.7))
    end

    it 'calculates the ride earnings based on ride distance and duration' do
      ride_distance = 5.0
      ride_duration = 5.0 / 60.0

      # Expect the ride_earnings method to calculate the earnings correctly
      expect(ride_earnings(ride_distance, ride_duration)).to eq(12 + (0.0 * 1.5) + (0.0 * 0.7))
    end

    it 'calculates the ride earnings based on ride distance and duration' do
      ride_distance = 20.0
      ride_duration = 20.0 / 60.0

      # Expect the ride_earnings method to calculate the earnings correctly
      expect(ride_earnings(ride_distance,
                           ride_duration)).to eq(12 + ((20.0 - 5.0) * 1.5) + ((20.0 - 15.0) * 0.7))
    end

    it 'calculates the ride earnings based on ride distance and duration' do
      ride_distance = 20.0
      ride_duration = 10.0 / 60.0

      # Expect the ride_earnings method to calculate the earnings correctly
      expect(ride_earnings(ride_distance,
                           ride_duration)).to eq(12 + ((20.0 - 5.0) * 1.5) + (0.0 * 0.7))
    end
  end

  describe '#score' do
    it 'calculates the score based on ride earnings, commute duration, and ride duration' do
      ride_earnings = 20.0
      commute_duration = 10.0
      ride_duration = 20.0

      # Expect the score method to calculate the score correctly
      expect(score(ride_earnings, commute_duration, ride_duration)).to eq(20.0 / (10.0 + 20.0))
    end

    it 'calculates the score based on ride earnings, commute duration, and ride duration' do
      ride_earnings = 20.0
      commute_duration = 20.0
      ride_duration = 20.0

      # Expect the score method to calculate the score correctly
      expect(score(ride_earnings, commute_duration, ride_duration)).to eq(20.0 / (20.0 + 20.0))
    end

    it 'calculates the score based on ride earnings, commute duration, and ride duration' do
      ride_earnings = 20.0
      commute_duration = 20.0
      ride_duration = 10.0

      # Expect the score method to calculate the score correctly
      expect(score(ride_earnings, commute_duration, ride_duration)).to eq(20.0 / (20.0 + 10.0))
    end

    it 'calculates the score based on ride earnings, commute duration, and ride duration' do
      ride_earnings = 20.0
      commute_duration = 10.0
      ride_duration = 10.0

      # Expect the score method to calculate the score correctly
      expect(score(ride_earnings, commute_duration, ride_duration)).to eq(20.0 / (10.0 + 10.0))
    end
  end

  describe '#get_data' do
    it 'returns a hash with data including commute distance, duration, ride earnings, and score' do
      home_address = instance_double(Address, id: Faker::Internet.uuid,
                                              address: "1588 E Thompson Blvd")
      start_address = instance_double(Address, id: Faker::Internet.uuid,
                                               address: "2112 E Thompson Blvd")
      destination_address = instance_double(Address, id: Faker::Internet.uuid,
                                                     address: "2112 E Thompson Blvd")

      # expect_any_instance_of(GoogleDirectionsApiClient).to receive(:get_directions).with(home_address.address, start_address.address).and_return([5.0, 10.0])
      # expect_any_instance_of(GoogleDirectionsApiClient).to receive(:get_directions).with(start_address.address, destination_address.address).and_return([5.0, 10.0])

      stub_request(:get, "https://maps.googleapis.com/maps/api/directions/json?origin=1588 E Thompson Blvd&destination=2112 E Thompson Blvd&key=#{Rails.application.credentials.google_api_key}")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Ruby"
          }
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

      stub_request(:get, "https://maps.googleapis.com/maps/api/directions/json?origin=2112 E Thompson Blvd&destination=2112 E Thompson Blvd&key=#{Rails.application.credentials.google_api_key}")
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

      # Expect the get_data method to return a hash with the correct data
      expect(get_data(home_address, start_address, destination_address)).to eq({
                                                                                 home_address: home_address,
                                                                                 start_address: start_address,
                                                                                 commute_distance: 5.0,
                                                                                 commute_duration: 10.0,
                                                                                 destination_address: destination_address,
                                                                                 ride_distance: 5.0,
                                                                                 ride_duration: 10.0,
                                                                                 ride_earnings: 421.5,
                                                                                 score: 21.075
                                                                               })
    end
  end
end
