require_relative "spec_helper"

describe "Weekly content engagement collector" do
  before(:each) do
    stub_credentials
    register_oauth_refresh
    register_api_discovery

    @ga_request = setup_ga_request(
      ids: "ga:56580952",
      metrics: "ga:totalEvents",
      dimensions: "ga:eventCategory,ga:eventAction,ga:eventLabel",
      filters: "ga:eventCategory=~^MS_.*;ga:eventCategory!=MS_transaction"
    )
  end

  it "should query google analytics for specific dates" do
    @ga_request.register(
      "2013-01-06", "2013-01-12",
      "weekly-content-engagement-from-2013-01-06.json"
    )
    collector = GoogleAnalytics::Collector.new(nil, [GoogleAnalytics::Config::WeeklyContentEngagementDetail.new(Date.new(2013, 1, 6),
                                                                                                   Date.new(2013, 1, 12))])

    response = collector.messages

    response[0].should be_for_collector("Google Analytics")
    response[0].should be_for_time_period(
                         DateTime.new(2013, 1, 6), DateTime.new(2013, 1, 13)
                       )
    response[0].should have_payload_value(
                         :site => "govuk",
                         :format => "answer",
                         :entries => 193,
                         :successes => 179,
                         :slug => "accepting-returns-and-giving-refunds"
                       )

    response[1].should have_payload_value(
                         :site => "govuk",
                         :format => "answer",
                         :entries => 101,
                         :successes => 71,
                         :slug => "acoustic-neuroma-and-driving"
                       )
    grouped_by_format = response
      .group_by { |each| each[:payload][:value][:format] }

    grouped_by_format.should have_key("answer")
    grouped_by_format.should have_key("guide")
  end
end