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

        run_test!
      end

      response(500, "Internal Server Error") do
        let(:driver_id) { 'e76885d9-dc50-4616-830e-cd24beefd7d9' }
        let(:page) { 0 }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        run_test!
      end
    end
  end
end
