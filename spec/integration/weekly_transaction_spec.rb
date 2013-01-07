require_relative "spec_helper"

describe "Weekly transaction success collector" do
  before(:each) do
    stub_credentials
    register_oauth_refresh
    register_api_discovery

    @ga_request = setup_ga_request(
      ids: "ga:61976178",
      metrics: "ga:totalEvents",
      dimensions: "ga:week,ga:eventCategory,ga:eventLabel",
      filters: "ga:eventCategory==MS_transaction"
    )
  end

  it "should query google analytics" do
    @ga_request.register("2012-12-30", "2013-01-05",
                         "weekly_transaction_response.json")

    collector = GoogleAnalytics::Collector.new(nil, [GoogleAnalytics::Config::WeeklyTransaction.new(Date.new(2012, 12, 30), Date.new(2013, 01, 5))])

    response = collector.collect_as_json
    response.should have(1).item

    r = response.first

    r.should be_for_collector("Google Analytics")
    r.should be_for_time_period(DateTime.new(2012,12,30), DateTime.new(2013,01,06))
    r.should have_payload_value(
      "site" => "govuk",
      "successes" => 1431421,
      "format" => "transaction"
    )
  end
end