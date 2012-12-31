require_relative "../../spec_helper"

describe "Daily Visitors Config" do

  before(:all) do
    @configs = GoogleAnalytics::Config::DailyVisitors.for(Date.new(2012, 8, 13))
  end

  it "should have an amqp_topic of google_analytics.visitors.daily" do
    @configs.amqp_topic.should == 'google_analytics.visitors.daily'
  end

  describe "analytics_parameters" do
    before(:all) do
      @p = @configs.analytics_parameters
    end

    it "should have ids" do
      @p["ids"].should == "ga:53872948"
    end

    it "should have a start date of 2012-08-13" do
      @p['start-date'].should == "2012-08-13"
    end

    it "should have a end date of 2012-08-13" do
      @p['end-date'].should == "2012-08-13"
    end

    it "should have a visits metric" do
      @p['metrics'].should == "ga:visitors"
    end

    it "should have a week dimension" do
      @p['dimensions'].should == "ga:day"
    end

    it "should have no filters" do
      @p['filters'].should be_nil
    end

  end
end