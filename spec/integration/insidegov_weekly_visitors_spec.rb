require_relative "spec_helper"

describe "Inside gov weekly visitors collector" do
  before(:each) do
    stub_credentials
    register_oauth_refresh
    register_api_discovery

    @ga_request = setup_ga_request(
      :ids => "ga:53699180",
      :metrics => "ga:visitors",
      :dimensions => ""
    )
  end

  it "should query google analytics for specific dates" do
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "insidegov-weekly-visitors-from-2012-12-23.json"
    )

    configs = [GoogleAnalytics::Config::InsideGovWeeklyVisitors.new(
                 Date.new(2012, 12, 23), Date.new(2012, 12, 29))]
    collector = GoogleAnalytics::Collector.new(nil, configs)

    response = collector.messages
    response.should have(1).item

    response[0].should be_for_collector("Google Analytics")
    response[0].should be_for_time_period(
                         Date.new(2012, 12, 23), Date.new(2012, 12, 30))
    response[0].should have_payload_value(
                         :visitors => 112822, :site => "insidegov")
  end

  it "should query google analytics for last week today" do
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "insidegov-weekly-visitors-from-2012-12-23.json"
    )

    Timecop.travel(DateTime.parse("2012-12-31")) do
      configs = GoogleAnalytics::Config::InsideGovWeeklyVisitors.all_within(
        Date.today - 1, Date.today)
      collector = GoogleAnalytics::Collector.new(nil, configs)

      response = collector.messages
      response.should have(1).item

      response[0].should be_for_time_period(
                           Date.new(2012, 12, 23), Date.new(2012, 12, 30))
      response[0].should have_payload_value(
                           :visitors => 112822, :site => "insidegov")
    end
  end

  it "should query google analytics for the previous three weeks" do
    @ga_request.register(
      "2012-12-09", "2012-12-15",
      "insidegov-weekly-visitors-from-2012-12-09.json"
    )
    @ga_request.register(
      "2012-12-16", "2012-12-22",
      "insidegov-weekly-visitors-from-2012-12-16.json"
    )
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "insidegov-weekly-visitors-from-2012-12-23.json"
    )
    Timecop.travel(DateTime.parse("2012-12-31")) do
      configs = GoogleAnalytics::Config::InsideGovWeeklyVisitors.all_within(
        Date.new(2012, 12, 10), Date.today)
      collector = GoogleAnalytics::Collector.new(nil, configs)

      response = collector.messages
      response.should have(3).items

      response[0].should be_for_time_period(
                           Date.new(2012, 12, 23), Date.new(2012, 12, 30))
      response[0].should have_payload_value(
                           :visitors => 112822, :site => "insidegov")

      response[1].should be_for_time_period(
                           Date.new(2012, 12, 16), Date.new(2012, 12, 23))
      response[1].should have_payload_value(
                           :visitors => 246417, :site => "insidegov")

      response[2].should be_for_time_period(
                           Date.new(2012, 12, 9), Date.new(2012, 12, 16))
      response[2].should have_payload_value(
                           :visitors => 181739, :site => "insidegov")
    end
  end
end
