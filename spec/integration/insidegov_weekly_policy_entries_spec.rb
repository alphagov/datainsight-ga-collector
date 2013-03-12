require_relative "spec_helper"

describe "Inside gov weekly policy entries collector" do
  before(:each) do
    stub_credentials
    register_oauth_refresh
    register_api_discovery

    @ga_request = setup_ga_request(
      :ids => "ga:53872948",
      :metrics => "ga:totalEvents",
      :dimensions => "ga:eventAction",
      :filters => "ga:eventCategory==IG_policy;ga:eventLabel==Entry"
    )
  end

  it "should query google analytics for specific dates" do
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "insidegov-weekly-policy-entries-from-2012-12-23.json"
    )

    configs = [GoogleAnalytics::Config::InsideGovWeeklyPolicyEntries.new(Date.new(2012, 12, 23), Date.new(2012, 12, 29))]
    collector = GoogleAnalytics::Collector.new(nil, configs)

    response = collector.messages
    response.should have(72).item

    response.each do |message|
      message.should be_for_collector("Google Analytics")
      message.should be_for_time_period(
                       DateTime.new(2012, 12, 23), DateTime.new(2012, 12, 30))
    end
    response[0].should have_payload_value(
       :site => "insidegov",
       :entries => 194,
       :slug => "boosting-private-sector-employment-in-england"
     )
  end

  it "should query google analytics for last week today" do
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "insidegov-weekly-policy-entries-from-2012-12-23.json"
    )

    Timecop.travel(DateTime.parse("2012-12-31")) do
      configs = GoogleAnalytics::Config::InsideGovWeeklyPolicyEntries.all_within(Date.today - 1, Date.today)
      collector = GoogleAnalytics::Collector.new(nil, configs)

      response = collector.messages
      response.should have(72).item

      response.each do |message|
        message.should be_for_collector("Google Analytics")
        message.should be_for_time_period(
                         DateTime.new(2012, 12, 23), DateTime.new(2012, 12, 30))
      end
      response[0].should have_payload_value(
                           :site => "insidegov",
                           :entries => 194,
                           :slug => "boosting-private-sector-employment-in-england"
                         )
    end
  end

  it "should query google analytics for the previous three weeks" do
    @ga_request.register(
      "2012-12-09", "2012-12-15",
      "insidegov-weekly-policy-entries-from-2012-12-09.json"
    )
    @ga_request.register(
      "2012-12-16", "2012-12-22",
      "insidegov-weekly-policy-entries-from-2012-12-16.json"
    )
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "insidegov-weekly-policy-entries-from-2012-12-23.json"
    )
    Timecop.travel(DateTime.parse("2012-12-31")) do
      configs = GoogleAnalytics::Config::InsideGovWeeklyPolicyEntries.all_within(
        Date.new(2012, 12, 10),
        Date.today
      )
      collector = GoogleAnalytics::Collector.new(nil, configs)

      response = collector.messages
      response.should have(218).items

      (0...72).each do |i|
        response[i].should be_for_collector("Google Analytics")
        response[i].should be_for_time_period(DateTime.new(2012, 12, 23), DateTime.new(2012, 12, 30))
      end
      (72...146).each do |i|
        response[i].should be_for_collector("Google Analytics")
        response[i].should be_for_time_period(DateTime.new(2012, 12, 16), DateTime.new(2012, 12, 23))
      end
      (146...218).each do |i|
        response[i].should be_for_collector("Google Analytics")
        response[i].should be_for_time_period(DateTime.new(2012, 12, 9), DateTime.new(2012, 12, 16))
      end

      response[0].should have_payload_value(
                           :site => "insidegov",
                           :entries => 194,
                           :slug => "boosting-private-sector-employment-in-england"
                         )
    end
  end
end