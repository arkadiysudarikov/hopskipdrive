# frozen_string_literal: true

# Exposes operational endpoints used by Kubernetes and monitoring.
class HealthController < ApplicationController
  def ready
    ActiveRecord::Base.connection.execute("SELECT 1")
    render json: { status: "ready" }
  rescue ActiveRecord::ActiveRecordError => e
    Rails.logger.warn("readiness_check_failed=#{e.class.name}")
    render json: { status: "not_ready" }, status: :service_unavailable
  end

  def metrics
    render plain: <<~METRICS, content_type: "text/plain; version=0.0.4"
      # HELP hopskipdrive_build_info Static application build information.
      # TYPE hopskipdrive_build_info gauge
      hopskipdrive_build_info{service="hopskipdrive-api",rails_env="#{Rails.env}"} 1
    METRICS
  end
end
