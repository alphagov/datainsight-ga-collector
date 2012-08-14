require_relative "../spec_helper"

describe "Hourly Collector Module" do

  class HourlyDummy
    include GoogleAnalytics::Config::HourlyCollector

    def initialize start_at, end_at
      @start_at, @end_at = start_at, end_at
    end

    attr_reader :start_at, :end_at
  end

  it "should create a range for today" do
    on_tuesday = HourlyDummy.last_before(Date.new(2012, 8, 9))

    on_tuesday.start_at.should eql(Date.new(2012, 8, 9))
    on_tuesday.end_at.should eql(Date.new(2012, 8, 9))
  end

  it "should create one day ranges between 2012-08-09 and 2012-08-09" do
    on_tuesday = HourlyDummy.all_within(Date.new(2012, 8, 9), Date.new(2012, 8, 9))

    on_tuesday.should be_a(Array)
    on_tuesday.should have(1).item

    on_tuesday = on_tuesday.first
    on_tuesday.start_at.should eql(Date.new(2012, 8, 9))
    on_tuesday.end_at.should eql(Date.new(2012, 8, 9))
  end

  it "should create four day ranges between 2012-08-08 and 2012-08-11" do
    four_days = HourlyDummy.all_within(Date.new(2012, 8, 8), Date.new(2012, 8, 11))

    four_days.should be_a(Array)
    four_days.should have(4).items

    four_days[0].start_at.should eql(Date.new(2012, 8, 8))
    four_days[1].start_at.should eql(Date.new(2012, 8, 9))
    four_days[2].start_at.should eql(Date.new(2012, 8, 10))
    four_days[3].start_at.should eql(Date.new(2012, 8, 11))
  end
end