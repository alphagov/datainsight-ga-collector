require_relative "spec_helper"

describe "Hourly visitors spec" do
  before(:each) do
    stub_credentials
    register_oauth_refresh
    register_api_discovery

    @ga_request = setup_ga_request(
      :ids => "ga:53872948",
      :metrics => "ga:visitors",
      :dimensions => "ga:hour"
    )
  end

  it "should query google analytics for a specific date" do
    @ga_request.register(
      "2012-12-29", "2012-12-29",
      "hourly-visitors-for-2012-12-29.json"
    )
    configs = [GoogleAnalytics::Config::HourlyVisitors.last_before(Date.new(2012, 12, 29))]
    collector = GoogleAnalytics::Collector.new(nil, configs)

    response = collector.collect_as_json
    response.should have(24).item

    response[0].should be_for_collector("Google Analytics")
    response[0].should be_for_time_period(
      DateTime.new(2012, 12, 29), DateTime.new(2012, 12, 29, 1))
    response[0].should have_payload_value(
      "visitors" => 14874, "site" => "govuk")

    response[23].should be_for_time_period(
      DateTime.new(2012, 12, 29, 23), DateTime.new(2012, 12, 30))
    response[23].should have_payload_value(
      "visitors" => 19272, "site" => "govuk")
  end

  it "should query google analytics for the previous three days" do
    @ga_request.register(
      "2012-12-27", "2012-12-27",
      "hourly-visitors-for-2012-12-27.json"
    )
    @ga_request.register(
      "2012-12-28", "2012-12-28",
      "hourly-visitors-for-2012-12-28.json"
    )
    @ga_request.register(
      "2012-12-29", "2012-12-29",
      "hourly-visitors-for-2012-12-29.json"
    )

    Timecop.travel(DateTime.parse("2012-12-29"))
    configs = GoogleAnalytics::Config::HourlyVisitors.all_within(
      Date.today - 2, Date.today)
    collector = GoogleAnalytics::Collector.new(nil, configs)

    response = collector.collect_as_json
    response.should have(72).items

    response[0].should be_for_time_period(
      DateTime.new(2012, 12, 27), DateTime.new(2012, 12, 27, 1))
    response[0].should have_payload_value(
      "visitors" => 11419, "site" => "govuk")

    response[24].should be_for_time_period(
      DateTime.new(2012, 12, 28), DateTime.new(2012, 12, 28, 1))
    response[24].should have_payload_value(
      "visitors" => 14577, "site" => "govuk")

    response[48].should be_for_time_period(
      DateTime.new(2012, 12, 29), DateTime.new(2012, 12, 29, 1))
    response[48].should have_payload_value(
       "visitors" => 14874, "site" => "govuk")
  end
end