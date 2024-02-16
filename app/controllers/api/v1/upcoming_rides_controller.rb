# frozen_string_literal: true

# API module
module Api
  # API::V1 module for version 1 of the API
  module V1
    # This controller is responsible for returning the upcoming rides for a driver
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
      rescue Pagy::OverflowError
        render json: { error: "Page out of range" }, status: :bad_request
      rescue Pagy::VariableError
        render json: { error: "{}" }, status: :internal_server_error
      end

      private

      def driver_params
        params.require(:driver_id)
      end
    end
  end
end
