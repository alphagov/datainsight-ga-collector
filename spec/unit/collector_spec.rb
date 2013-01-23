require "spec_helper"

describe GoogleAnalytics::Collector do

  it "should not allow configs of different types" do
    configs = [
      GoogleAnalytics::Config::WeeklyVisits.new(Date.today - 6, Date.today),
      GoogleAnalytics::Config::WeeklyVisitors.new(Date.today - 6, Date.today)
    ]

    lambda {GoogleAnalytics::Collector.new("any-code", configs)}.should raise_exception
  end
end