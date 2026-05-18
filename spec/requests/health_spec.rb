# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Health checks" do
  let(:database_connection) { ActiveRecord::Base.connection }

  describe "GET /ready" do
    it "returns ready when the database accepts a simple query", :aggregate_failures do
      allow(database_connection).to receive(:execute).with("SELECT 1")

      get "/ready"

      expect(response.ok?).to be(true)
      expect(response.parsed_body).to eq("status" => "ready")
    end

    it "returns service unavailable when the database check fails", :aggregate_failures do
      failure = ActiveRecord::ConnectionNotEstablished
      allow(database_connection).to receive(:execute).and_raise(failure)

      get "/ready"

      expect([response.status, response.parsed_body]).to eq([503, { "status" => "not_ready" }])
    end
  end

  describe "GET /metrics" do
    it "exposes a scrapeable build info metric", :aggregate_failures do
      get "/metrics"

      expect(response.ok?).to be(true)
      expect(response.body.include?("hopskipdrive_build_info")).to be(true)
    end
  end
end
