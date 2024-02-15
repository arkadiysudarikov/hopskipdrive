# frozen_string_literal: true

require "swagger_helper"

RSpec.describe 'api/v1/upcoming_rides' do
  path '/api/v1/drivers/{driver_id}/upcoming_rides' do
    # You'll want to customize the parameter types...
    parameter name: "driver_id", in: :path, type: :string, description: "Driver ID"
    parameter name: "page", in: :query, type: :string, description: "Page number"

    get('list upcoming rides') do
      response(404, "Not Found") do
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
    end
  end
end
