require_relative "../../spec_helper"

describe "Inside Gov Weekly Entry and Success Config" do

  before(:all) do
    @configs = GoogleAnalytics::Config::InsideGovWeeklyEntrySuccess.last_before(Date.new(2012, 8, 13))
  end

  specify { @configs.amqp_topic.should == 'google_analytics.insidegov.entry_and_success.weekly' }

  describe "analytics_parameters" do
    before(:all) do
      @p = @configs.analytics_parameters
    end

    specify { @p["ids"].should == "ga:53872948" }
    specify { @p["metrics"].should == "ga:totalEvents" }
    specify { @p["dimensions"].should == "ga:week,ga:eventCategory,ga:eventLabel" }
    specify { @p["start-date"].should == "2012-08-05" }
    specify { @p["end-date"].should == "2012-08-11" }
    specify { @p["filters"].should == "ga:eventCategory=~^IG_.*" }

  end
end