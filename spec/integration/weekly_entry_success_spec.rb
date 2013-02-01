require_relative "spec_helper"

describe "Weekly content engagement collector" do
  before(:each) do
    stub_credentials
    register_oauth_refresh
    register_api_discovery

    @ga_request = setup_ga_request(
      :ids => "ga:53872948",
      :metrics => "ga:totalEvents",
      :dimensions => "ga:eventCategory,ga:eventLabel",
      :filters => "ga:eventCategory=~^MS_.*"
    )
  end

  it "should query google analytics for specific dates" do
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "weekly-content-engagement-from-2012-12-23.json"
    )

    collector = GoogleAnalytics::Collector.new(nil, [GoogleAnalytics::Config::WeeklyContentEngagement.new(Date.new(2012, 12, 23), Date.new(2012, 12, 29))])

    response = collector.messages
    response.should have(5).item

    response[0].should be_for_collector("Google Analytics")
    response[0].should be_for_time_period(
                         DateTime.new(2012, 12, 23), DateTime.new(2012, 12, 30)
                       )
    response[0].should have_payload_value(
                         :site => "govuk",
                         :format => "answer",
                         :entries => 956935,
                         :successes => 749668
                       )

    response[1].should have_payload_value(
                         :format => "guide",
                         :entries => 744263,
                         :successes => 604024
                       )

    response[2].should have_payload_value(
                         :format => "programme",
                         :entries => 530724,
                         :successes => 422019
                       )
  end

  it "should query google analytics for last week today" do
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "weekly-content-engagement-from-2012-12-23.json"
    )

    Timecop.travel(DateTime.parse("2012-12-31")) do
      collector = GoogleAnalytics::Collector.new(nil, GoogleAnalytics::Config::WeeklyContentEngagement.all_within(Date.today - 1, Date.today))

      response = collector.messages
      response.should have(5).item

      response[0].should be_for_time_period(
                           DateTime.new(2012, 12, 23), DateTime.new(2012, 12, 30)
                         )
      response[0].should have_payload_value(
                           :site => "govuk",
                           :format => "answer",
                           :entries => 956935,
                           :successes => 749668
                         )
    end
  end

  it "should query google analytics for the previous three weeks" do
    @ga_request.register(
      "2012-12-09", "2012-12-15",
      "weekly-content-engagement-from-2012-12-09.json"
    )
    @ga_request.register(
      "2012-12-16", "2012-12-22",
      "weekly-content-engagement-from-2012-12-16.json"
    )
    @ga_request.register(
      "2012-12-23", "2012-12-29",
      "weekly-content-engagement-from-2012-12-23.json"
    )
    Timecop.travel(DateTime.parse("2012-12-31")) do
      configs = GoogleAnalytics::Config::WeeklyContentEngagement.all_within(
        Date.new(2012, 12, 10),
        Date.today
      )
      collector = GoogleAnalytics::Collector.new(nil, configs)

      response = collector.messages
      response.should have(15).items

      response[0].should be_for_time_period(
                           Date.new(2012, 12, 9), Date.new(2012, 12, 16)
                         )
      response[0].should have_payload_value(
                           :site => "govuk",
                           :format => "answer",
                           :entries => 1458580,
                           :successes => 1115508
                         )

      response[1].should have_payload_value(
                           :format => "guide",
                           :entries => 1253538,
                           :successes => 1018108
                         )

      response[4].should be_for_time_period(
                           Date.new(2012, 12, 9), Date.new(2012, 12, 16)
                         )
      response[5].should be_for_time_period(
                           Date.new(2012, 12, 16), Date.new(2012, 12, 23)
                         )
      response[9].should be_for_time_period(
                           Date.new(2012, 12, 16), Date.new(2012, 12, 23)
                         )
      response[10].should be_for_time_period(
                            Date.new(2012, 12, 23), Date.new(2012, 12, 30)
                         )
    end
  end

end