require_relative "../spec_helper"

describe "Weekly Visits Config" do
  before(:all) do
    @weekly_visits_config = GoogleAnalytics::Config::WeeklyVisits.new(Date.new(2012, 8, 13))
  end

  it "should have an amqp_topic of google_analytics.visits.weekly" do
    @weekly_visits_config.amqp_topic.should == 'google_analytics.visits.weekly'
  end

  describe "analytics_parameters" do
    before(:all) do
      @p = @weekly_visits_config.analytics_parameters
    end

    it "should have ids" do
      @p["ids"].should == "ga:53872948"
    end

    it "should have a start date of 2012-08-05" do
      @p['start-date'].should == "2012-08-05"
    end

    it "should have a end date of 2012-08-11" do
      @p['end-date'].should == "2012-08-11"
    end

    it "should have a visits metric" do
      @p['metrics'].should == "ga:visits"
    end

    it "should have a week dimension" do
      @p['dimensions'].should == "ga:week"
    end

    it "should have no filters" do
      @p['filters'].should be_nil
    end
  end

end
