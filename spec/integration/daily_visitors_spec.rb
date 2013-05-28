require_relative "spec_helper"

describe "Daily visitors spec" do
  before(:each) do
    stub_credentials
    register_oauth_refresh
    register_api_discovery

    @ga_request = setup_ga_request(
      :ids => "ga:56580952",
      :metrics => "ga:visitors",
      :dimensions => "ga:day"
    )
  end

  it "should query google analytics for a specific date" do
    @ga_request.register(
      "2012-12-29", "2012-12-29",
      "daily-visitors-for-2012-12-29.json"
    )
    configs = [GoogleAnalytics::Config::DailyVisitors.for(Date.new(2012, 12, 29))]
    collector = GoogleAnalytics::Collector.new(nil, configs)

    response = collector.messages
    response.should have(1).item

    response[0].should be_for_collector("Google Analytics")
    response[0].should be_for_time_period(
                         Date.new(2012, 12, 29), Date.new(2012, 12, 30))
    response[0].should have_payload_value(
                         :visitors => 491836, :site => "govuk")

  end

  it "should query google analytics for the previous three days" do
    @ga_request.register(
      "2012-12-27", "2012-12-27",
      "daily-visitors-for-2012-12-27.json"
    )
    @ga_request.register(
      "2012-12-28", "2012-12-28",
      "daily-visitors-for-2012-12-28.json"
    )
    @ga_request.register(
      "2012-12-29", "2012-12-29",
      "daily-visitors-for-2012-12-29.json"
    )

    Timecop.travel(DateTime.parse("2012-12-29"))
    configs = GoogleAnalytics::Config::DailyVisitors.all_within(
      Date.today - 2, Date.today)
    collector = GoogleAnalytics::Collector.new(nil, configs)

    response = collector.messages
    response.should have(3).items

    response[2].should be_for_time_period(
      Date.new(2012, 12, 27), Date.new(2012, 12, 28))
    response[2].should have_payload_value(
      :visitors => 595545, :site => "govuk")

    response[1].should be_for_time_period(
      Date.new(2012, 12, 28), Date.new(2012, 12, 29))
    response[1].should have_payload_value(
      :visitors => 649363, :site => "govuk")

    response[0].should be_for_time_period(
      Date.new(2012, 12, 29), Date.new(2012, 12, 30))
    response[0].should have_payload_value(
      :visitors => 491836, :site => "govuk")
  end
end