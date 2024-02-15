# frozen_string_literal: true

# API module
module Api
  # API::V1 module for version 1 of the API
  module V1
    # UpcomingRidesController for the API
    # This controller is responsible for returning upcoming rides for a driver
    # It includes the UpcomingRides module
    # It includes the Pagy::Backend module for pagination
    # It inherits from ApplicationController
    # It has an index method
    # It has a private driver_params method
    class UpcomingRidesController < ApplicationController
      include UpcomingRides
      include Pagy::Backend

      def index
        @driver = Driver.find(driver_params)
        @rides = Ride.eager_load(:start_address, :destination_address).all

        pagy, upcoming_rides = pagy_array(upcoming_rides(@driver, @rides))

        pagy_headers_merge(pagy)

        render json: upcoming_rides
      rescue DirectionsAPIError => e
        render json: { error: e.message }, status: :service_unavailable
      end

      private

      def driver_params
        params.require(:driver_id)
      end
    end
  end
end
