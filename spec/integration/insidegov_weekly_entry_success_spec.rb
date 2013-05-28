require_relative "spec_helper"

describe "Inside gov weekly content engagement collector" do
  before(:each) do
    stub_credentials
    register_oauth_refresh
    register_api_discovery

    @ga_request = setup_ga_request(
      :ids => "ga:56580952",
      :metrics => "ga:totalEvents",
      :dimensions => "ga:eventCategory,ga:eventLabel",
      :filters => "ga:eventCategory=~^IG_.*"
    )
  end

  it "should query google analytics for specific dates" do
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "insidegov-weekly-content-engagement-from-2012-12-23.json"
    )

    configs = [GoogleAnalytics::Config::InsideGovWeeklyContentEngagement.new(Date.new(2012, 12, 23), Date.new(2012, 12, 29))]
    collector = GoogleAnalytics::Collector.new(nil, configs)

    response = collector.messages
    response.should have(3).item

    response[0].should be_for_collector("Google Analytics")
    response[0].should be_for_time_period(
                         DateTime.new(2012, 12, 23), DateTime.new(2012, 12, 30)
                       )
    response[0].should have_payload_value(
                         :site => "insidegov",
                         :format => "detailed_guidance",
                         :entries => 45302,
                         :successes => 30605
                       )

    response[1].should have_payload_value(
                         :format => "news",
                         :entries => 44323,
                         :successes => 27929
                       )

    response[2].should have_payload_value(
                         :format => "policy",
                         :entries => 14358,
                         :successes => 8495
                       )
  end

  it "should query google analytics for last week today" do
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "insidegov-weekly-content-engagement-from-2012-12-23.json"
    )

    Timecop.travel(DateTime.parse("2012-12-31")) do
      configs = GoogleAnalytics::Config::InsideGovWeeklyContentEngagement.all_within(Date.today - 1, Date.today)
      collector = GoogleAnalytics::Collector.new(nil, configs)

      response = collector.messages
      response.should have(3).item

      response[0].should be_for_time_period(
                           DateTime.new(2012, 12, 23), DateTime.new(2012, 12, 30)
                         )
      response[0].should have_payload_value(
                           :site => "insidegov",
                           :format => "detailed_guidance",
                           :entries => 45302,
                           :successes => 30605
                         )
    end
  end

  it "should query google analytics for the previous three weeks" do
    @ga_request.register(
      "2012-12-09", "2012-12-15",
      "insidegov-weekly-content-engagement-from-2012-12-09.json"
    )
    @ga_request.register(
      "2012-12-16", "2012-12-22",
      "insidegov-weekly-content-engagement-from-2012-12-16.json"
    )
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "insidegov-weekly-content-engagement-from-2012-12-23.json"
    )
    Timecop.travel(DateTime.parse("2012-12-31")) do
      configs = GoogleAnalytics::Config::InsideGovWeeklyContentEngagement.all_within(
        Date.new(2012, 12, 10),
        Date.today
      )
      collector = GoogleAnalytics::Collector.new(nil, configs)

      response = collector.messages
      response.should have(9).items

      response[0].should be_for_time_period(
                           Date.new(2012, 12, 23), Date.new(2012, 12, 30)
                         )
      response[0].should have_payload_value(
                           :site => "insidegov",
                           :format => "detailed_guidance",
                           :entries => 45302,
                           :successes => 30605
                         )

      response[1].should have_payload_value(
                           :format => "news",
                           :entries => 44323,
                           :successes => 27929
                         )

      response[2].should be_for_time_period(
                           Date.new(2012, 12, 23), Date.new(2012, 12, 30)
                         )
      response[3].should be_for_time_period(
                           Date.new(2012, 12, 16), Date.new(2012, 12, 23)
                         )
      response[5].should be_for_time_period(
                           Date.new(2012, 12, 16), Date.new(2012, 12, 23)
                         )
      response[6].should be_for_time_period(
                           Date.new(2012, 12, 9), Date.new(2012, 12, 16)
                         )
    end
  end

end