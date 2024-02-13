class Api::V1::UpcomingRidesController < ApplicationController
  def index
    upcoming_rides = Ride.upcoming_rides

    render json: upcoming_rides
  end
end
