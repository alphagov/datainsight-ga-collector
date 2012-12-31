require_relative "../../spec_helper"

describe "Weekly Policy Entries Config" do
  before(:all) do
    @weekly_policy_entries_config = GoogleAnalytics::Config::InsideGovWeeklyPolicyEntries.last_before(Date.new(2012, 8, 13))
  end

  it "should have an amqp_topic of google_analytics.insidegov.policy_entries.weekly" do
    @weekly_policy_entries_config.amqp_topic.should == "google_analytics.insidegov.policy_entries.weekly"
  end

  describe "analytics_parameters" do
    before(:all) do
      @p = @weekly_policy_entries_config.analytics_parameters
    end

    it "should have ids" do
      @p["ids"].should == "ga:53872948"
    end

    it "should have a start date of 2012-08-05" do
      @p["start-date"].should == "2012-08-05"
    end

    it "should have a end date of 2012-08-11" do
      @p["end-date"].should == "2012-08-11"
    end

    it "should have a total events metric" do
      @p["metrics"].should == "ga:totalEvents"
    end

    it "should have a week and eventAction dimension" do
      @p["dimensions"].should == "ga:week,ga:eventAction"
    end

    it "should have filters for entries to policy formats" do
      @p["filters"].should == "ga:eventCategory==IG_policy;ga:eventLabel==Entry"
    end
  end

end
