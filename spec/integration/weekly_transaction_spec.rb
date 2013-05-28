require_relative "spec_helper"

describe "Weekly transaction success collector" do
  before(:each) do
    stub_credentials
    register_oauth_refresh
    register_api_discovery

    @ga_request_1 = setup_ga_request(
      ids: "ga:61976178",
      metrics: "ga:totalEvents",
      dimensions: "ga:eventCategory,ga:eventLabel",
      filters: "ga:eventCategory==MS_transaction"
    )

    @ga_request_2 = setup_ga_request(
      ids: "ga:56580952",
      metrics: "ga:totalEvents",
      dimensions: "ga:eventCategory,ga:eventLabel",
      filters: "ga:eventCategory==MS_transaction"
    )
  end

  it "should query google analytics" do
    @ga_request_1.register("2012-12-30", "2013-01-05",
                         "weekly_transaction_response.json")

    @ga_request_2.register("2012-12-30", "2013-01-05",
                            "weekly_transaction_response.json")

    collector = GoogleAnalytics::Collector.new(nil, [GoogleAnalytics::Config::WeeklyContentEngagementTransaction.new(Date.new(2012, 12, 30), Date.new(2013, 01, 5))])

    response = collector.messages
    response.should have(1).item

    r = response.first

    r.should be_for_collector("Google Analytics")
    r.should be_for_time_period(DateTime.new(2012,12,30), DateTime.new(2013,01,06))
    r.should have_payload_value(
      :site => "govuk",
      :successes => (1431421*2),
      :format => "transaction"
    )
  end

  it "should query google analytics for historical queries" do
    @ga_request_1.register("2012-12-23", "2012-12-29",
                         "weekly_transaction_response__2012-12-23.json")
    @ga_request_1.register("2012-12-16", "2012-12-22",
                         "weekly_transaction_response__2012-12-16.json")
    @ga_request_1.register("2012-12-09", "2012-12-15",
                         "weekly_transaction_response__2012-12-09.json")

    @ga_request_2.register("2012-12-23", "2012-12-29",
                          "weekly_transaction_response__2012-12-23.json")
    @ga_request_2.register("2012-12-16", "2012-12-22",
                          "weekly_transaction_response__2012-12-16.json")
    @ga_request_2.register("2012-12-09", "2012-12-15",
                           "weekly_transaction_response__2012-12-09.json")

    Timecop.travel(DateTime.parse("2012-12-31")) do
      configs = GoogleAnalytics::Config::WeeklyContentEngagementTransaction.all_within(Date.new(2012,12,9),Date.today)
      collector = GoogleAnalytics::Collector.new(nil, configs)

      response = collector.messages
      response.should have(3).items

      response.first.should be_for_time_period(Date.new(2012,12,23), Date.new(2012,12,30))
      response[1].should be_for_time_period(Date.new(2012,12,16), Date.new(2012,12,23))
      response[2].should be_for_time_period(Date.new(2012,12,9), Date.new(2012,12,16))
    end
  end
end