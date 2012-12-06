require_relative "../spec_helper"

describe "Weekly Policy Visits Config" do
  before(:all) do
    @weekly_policy_visits_config = GoogleAnalytics::Config::InsideGovWeeklyPolicyVisits.last_before(Date.new(2012, 8, 13))
  end

  it "should have an amqp_topic of google_analytics.insidegov.policy_visits.weekly"

  describe "analytics_parameters" do
    before(:all) do
      @p = @weekly_policy_visits_config.analytics_parameters
    end

    it "should have ids"

    it "should have a start date of 2012-08-05"

    it "should have a end date of 2012-08-11"

    it "should have a visits metric"

    it "should have a slug"

    it "should have a week dimension"

    it "should have filters for policies"
  end

end
