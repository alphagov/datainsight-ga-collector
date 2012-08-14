require_relative "../spec_helper"

describe "Hourly Collector Module" do

  class HourlyDummy < GoogleAnalytics::Config::Base
    include GoogleAnalytics::Config::HourlyCollector

    attr_reader :start_at, :end_at
  end

  let(:a_wednesday) {Date.new(2012, 8, 8)}
  let(:a_thursday) {Date.new(2012, 8, 9)}
  let(:a_friday) {Date.new(2012, 8, 10)}
  let(:a_saturday) {Date.new(2012, 8, 11)}

  it "should have a response type of WeeklyResponse" do
    weekly_config = HourlyDummy.last_before(a_thursday)

    weekly_config.response_type.should be(GoogleAnalytics::HourlyResponse)
  end

  it "should create a range for today" do
    on_thursday = HourlyDummy.last_before(a_thursday)

    on_thursday.start_at.should eql(a_thursday)
    on_thursday.end_at.should eql(a_thursday)
  end

  it "should create one day ranges between 2012-08-09 and 2012-08-09" do
    on_thursday = HourlyDummy.all_within(a_thursday, a_thursday)

    on_thursday.should be_a(Array)
    on_thursday.should have(1).item

    on_thursday = on_thursday.first
    on_thursday.start_at.should eql(a_thursday)
    on_thursday.end_at.should eql(a_thursday)
  end

  it "should create four day ranges between 2012-08-08 and 2012-08-11" do
    four_days = HourlyDummy.all_within(a_wednesday, a_saturday)

    four_days.should be_a(Array)
    four_days.should have(4).items

    four_days[0].start_at.should eql(a_wednesday)
    four_days[1].start_at.should eql(a_thursday)
    four_days[2].start_at.should eql(a_friday)
    four_days[3].start_at.should eql(a_saturday)
  end
end