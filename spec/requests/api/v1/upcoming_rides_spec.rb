require 'swagger_helper'

RSpec.describe 'api/v1/upcoming_rides', type: :request do
  path '/api/v1/drivers/{driver_id}/upcoming_rides' do
    parameter name: 'driver_id', in: :path, type: :string, description: 'driver_id'

    get('list upcoming rides') do
      response(200, 'successful') do
        let(:driver_id) { 'e76885d9-dc50-4616-830e-cd24beefd7d9' }

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
