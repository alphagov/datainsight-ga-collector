require_relative "spec_helper"

describe GoogleAnalytics::Client do
  before :each do
    stub_credentials
    register_oauth_refresh
    register_api_discovery
  end

  it "should return data from google analytics API" do
    ga_request = setup_ga_request(:ids => "ga:0", :metrics => "ga:stub-metric")
    ga_request.register("2012-01-01", "2012-01-31", "weekly_transaction_response.json")

    client = GoogleAnalytics::Client.new("some-auth-code")

    data = client.query({ "ids" => "ga:0",
                          "metrics" => "ga:stub-metric",
                          "start-date" => "2012-01-01",
                          "end-date" => "2012-01-31" })

    data["rows"].should_not be_empty
  end
end