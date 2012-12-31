require_relative "spec_helper"

describe "Weekly visitors collector" do
  before(:each) do
    stub_credentials
    register_oauth_refresh
    register_api_discovery
  end

  it "should query google analytics for specific dates" do
    register_ga_request(
      {
        :ids => "ga:53872948",
        :"start-date" => "2012-12-23",
        :"end-date" => "2012-12-29",
        :metrics => "ga:visitors",
        :dimensions => "ga:week"
      },
      load_data("weekly-visitors-from-2012-12-23.json")
    )

    collector = GoogleAnalytics::Collector.new(nil, [GoogleAnalytics::Config::WeeklyVisitors.new(Date.new(2012, 12, 23), Date.new(2012, 12, 29))])

    response = collector.collect_as_json
    response.should have(1).item
    message = JSON.parse(response.first)
    message["envelope"]["collector"].should == "Google Analytics"
    message["payload"].should == {
      "start_at" => "2012-12-23T00:00:00+00:00",
      "end_at" => "2012-12-30T00:00:00+00:00",
      "value" => {"visitors" => 2474699, "site" => "govuk"}
    }
  end

  it "should query google analytics for last week today" do
    register_ga_request(
      {
        :dimensions => "ga:week",
        :"end-date" => "2012-12-29",
        :ids => "ga:53872948",
        :metrics => "ga:visitors",
        :"start-date" => "2012-12-23"
      },
      load_data("weekly-visitors-from-2012-12-23.json")
    )

    Timecop.travel(DateTime.parse("2012-12-31")) do
      collector = GoogleAnalytics::Collector.new(nil, GoogleAnalytics::Config::WeeklyVisitors.all_within(Date.today - 1, Date.today))

      response = collector.collect_as_json
      response.should have(1).item
      message = JSON.parse(response.first)
      message["envelope"]["collector"].should == "Google Analytics"
      message["payload"].should == {
        "start_at" => "2012-12-23T00:00:00+00:00",
        "end_at" => "2012-12-30T00:00:00+00:00",
        "value" => {"visitors" => 2474699, "site" => "govuk"}
      }
    end
  end

  it "should query google analytics for the previous three weeks" do
    register_ga_request(
      {
        :dimensions => "ga:week",
        :"end-date" => "2012-12-29",
        :ids => "ga:53872948",
        :metrics => "ga:visitors",
        :"start-date" => "2012-12-23"
      },
      load_data("weekly-visitors-from-2012-12-23.json")
    )
    register_ga_request(
      {
        :dimensions => "ga:week",
        :"end-date" => "2012-12-22",
        :ids => "ga:53872948",
        :metrics => "ga:visitors",
        :"start-date" => "2012-12-16"
      },
      load_data("weekly-visitors-from-2012-12-16.json")
    )
    register_ga_request(
      {
        :dimensions => "ga:week",
        :"end-date" => "2012-12-15",
        :ids => "ga:53872948",
        :metrics => "ga:visitors",
        :"start-date" => "2012-12-09"
      },
      load_data("weekly-visitors-from-2012-12-09.json")
    )
    Timecop.travel(DateTime.parse("2012-12-31")) do
      collector = GoogleAnalytics::Collector.new(nil,
        GoogleAnalytics::Config::WeeklyVisitors.all_within(Date.new(2012, 12, 10), Date.today)
      )

      response = collector.collect_as_json
      response.should have(3).items

      message = JSON.parse(response[0])
      message["payload"].should == {
        "start_at" => "2012-12-09T00:00:00+00:00",
        "end_at" => "2012-12-16T00:00:00+00:00",
        "value" => {"visitors" => 3903764, "site" => "govuk"}
      }

      message = JSON.parse(response[1])
      message["payload"].should == {
        "start_at" => "2012-12-16T00:00:00+00:00",
        "end_at" => "2012-12-23T00:00:00+00:00",
        "value" => {"visitors" => 3715016, "site" => "govuk"}
      }

      message = JSON.parse(response[2])
      message["payload"].should == {
        "start_at" => "2012-12-23T00:00:00+00:00",
        "end_at" => "2012-12-30T00:00:00+00:00",
        "value" => {"visitors" => 2474699, "site" => "govuk"}
      }
    end
  end
end
