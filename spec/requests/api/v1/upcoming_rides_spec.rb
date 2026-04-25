# frozen_string_literal: true

require "swagger_helper"

RSpec.describe 'api/v1/upcoming_rides' do
  let(:headers) do
    {
      "Accept" => "*/*",
      "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
      "User-Agent" => "Ruby"
    }
  end

  before do
    ["1588 E Thomspon Blvd",
     "2112 E Thompson Blvd"].each do |address|
      Address.find_or_create_by!(address: address)
    end

    Driver.find_or_create_by!(id: "e76885d9-dc50-4616-830e-cd24beefd7d9",
                              home_address: Address.first)

    Ride.find_or_create_by(start_address: Address.first, destination_address: Address.second)

    [
      ["1588 E Thomspon Blvd", "1588 E Thomspon Blvd"],
      ["2112 E Thompson Blvd", "2112 E Thompson Blvd"],
      ["1588 E Thomspon Blvd", "2112 E Thompson Blvd"],
      ["2112 E Thompson Blvd", "1588 E Thomspon Blvd"]
    ].each do |addresses|
      stub_request(:get, "https://maps.googleapis.com/maps/api/directions/json?destination=#{addresses.first}&key=#{Rails.application.credentials.google_api_key}&origin=#{addresses.second}")
        .with(
          headers: headers
        ).to_return(status: 200, body: '{
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
    end
  end

  path '/api/v1/drivers/{driver_id}/upcoming_rides' do
    # You'll want to customize the parameter types...
    parameter name: "driver_id", in: :path, type: :string, description: "Driver ID"
    parameter name: "page", in: :query, type: :string, description: "Page number"

    get('List Upcoming Rides') do
      response(200, "Successful") do
        let(:driver_id) { 'e76885d9-dc50-4616-830e-cd24beefd7d9' }
        let(:page) { 1 }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response(404, "Not Found") do
        let(:driver_id) { '123' }
        let(:page) { 1 }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end

      response(400, "Bad Request") do
        let(:driver_id) { 'e76885d9-dc50-4616-830e-cd24beefd7d9' }
        let(:page) { 2 }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test! do |response|
          expect(JSON.parse(response.body)).to eq("error" => "Page out of range")
        end
      end

      response(400, "Bad Request (Invalid Page Param)") do
        let(:driver_id) { 'e76885d9-dc50-4616-830e-cd24beefd7d9' }
        let(:page) { 0 }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test! do |response|
          expect(JSON.parse(response.body)["error"]).to include("Invalid pagination parameter")
        end
      end
    end
  end

  describe "score ordering before pagination" do
    before do
      Rails.cache.clear
      Ride.delete_all
      Driver.delete_all
      Address.delete_all

      home_address = Address.create!(address: "Regression Home")
      @driver = Driver.create!(id: "e76885d9-dc50-4616-830e-cd24beefd7d9", home_address: home_address)
      @rides = [
        create_ride("Low Score 1", 10),
        create_ride("Low Score 2", 20),
        create_ride("Low Score 3", 30),
        create_ride("Low Score 4", 40),
        create_ride("Low Score 5", 50),
        create_ride("High Score 1", 100),
        create_ride("High Score 2", 90)
      ]
      @scores_by_ride_id = @rides.to_h { |ride, score| [ride.id, score] }
      @scored_ride_ids = []

      allow_any_instance_of(Api::V1::UpcomingRidesController).to receive(:add_ride_attributes) do |_controller, driver, ride|
        expect(driver).to eq(@driver)

        @scored_ride_ids << ride.id
        ride.attributes.merge(score: @scores_by_ride_id.fetch(ride.id))
      end
    end

    it "returns the highest scoring rides on the first page even when they were created after lower scoring rides" do
      get "/api/v1/drivers/#{@driver.id}/upcoming_rides", params: { page: 1 }

      expect(response).to have_http_status(:ok)
      expect(response_ids).to eq(expected_ids_for_page(1))
    end

    it "returns the remaining globally sorted rides on the second page" do
      get "/api/v1/drivers/#{@driver.id}/upcoming_rides", params: { page: 2 }

      expect(response).to have_http_status(:ok)
      expect(response_ids).to eq(expected_ids_for_page(2))
    end

    it "scores every ride before paginating the response" do
      get "/api/v1/drivers/#{@driver.id}/upcoming_rides", params: { page: 1 }

      expect(response).to have_http_status(:ok)
      expect(@scored_ride_ids).to match_array(@rides.map(&:first).map(&:id))
    end

    it "keeps all page 1 scores greater than or equal to all page 2 scores" do
      get "/api/v1/drivers/#{@driver.id}/upcoming_rides", params: { page: 1 }
      page_1_scores = response_scores

      get "/api/v1/drivers/#{@driver.id}/upcoming_rides", params: { page: 2 }
      page_2_scores = response_scores

      expect(page_1_scores.min).to be >= page_2_scores.max
    end
  end

  def create_ride(label, score)
    start_address = Address.create!(address: "#{label} Start")
    destination_address = Address.create!(address: "#{label} Destination")

    [Ride.create!(start_address: start_address, destination_address: destination_address), score]
  end

  def expected_ids_for_page(page)
    @rides
      .sort_by { |_ride, score| -score }
      .map { |ride, _score| ride.id }
      .each_slice(Pagy::DEFAULT[:items])
      .to_a
      .fetch(page - 1)
  end

  def response_ids
    JSON.parse(response.body).map { |ride| ride.fetch("id") }
  end

  def response_scores
    JSON.parse(response.body).map { |ride| ride.fetch("score") }
  end
end
