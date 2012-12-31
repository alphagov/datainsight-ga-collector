require_relative "../../spec_helper"

describe GoogleAnalytics::Config::Base do

  it "should have WeeklyVisits in its descendants" do
    GoogleAnalytics::Config::Base.descendants.should include("WeeklyVisits")
  end

  it "should have WeeklyUniqueVistors in its descendants" do
    GoogleAnalytics::Config::Base.descendants.should include("WeeklyVisitors")
  end

  it "should not have itself in its descendants" do
    GoogleAnalytics::Config::Base.descendants.should_not include("Base")
  end
end