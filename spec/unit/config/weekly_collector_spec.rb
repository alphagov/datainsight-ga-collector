require_relative "../spec_helper"

describe "Weekly Collector Module" do

  class WeeklyDummy < GoogleAnalytics::Config::Base
    include GoogleAnalytics::Config::WeeklyCollector

    attr_reader :start_at, :end_at
  end

  it "should have a response type of WeeklyResponse" do
    weekly_config = WeeklyDummy.last_before(Date.new(2012, 8, 9))

    weekly_config.response_type.should be(GoogleAnalytics::WeeklyResponse)
  end

  it "should create a range for the last week" do
    on_tuesday = WeeklyDummy.last_before(Date.new(2012, 8, 9))

    on_tuesday.start_at.should eql(Date.new(2012, 7, 29))
    on_tuesday.end_at.should eql(Date.new(2012, 8, 4))
  end

  it "should go back to last saturday, if passed date is a saturday" do
    on_saturday = WeeklyDummy.last_before(Date.new(2012, 3, 17))

    on_saturday.start_at.should eql(Date.new(2012, 3, 4))
    on_saturday.end_at.should eql(Date.new(2012, 3, 10))
  end

  it "should use exact week when given" do
    one_week = WeeklyDummy.all_within(Date.new(2012, 8, 5), Date.new(2012, 8, 12))

    one_week.should be_an(Array)
    one_week = one_week.first

    one_week.start_at.should == Date.new(2012, 8, 5)
    one_week.end_at.should == Date.new(2012, 8, 11)
  end

  it "should not include the week were the end date is in" do
    one_week = WeeklyDummy.all_within(Date.new(2012, 8, 5), Date.new(2012, 8, 18)).first

    one_week.start_at.should == Date.new(2012, 8, 5)
    one_week.end_at.should == Date.new(2012, 8, 11)
  end

  it "should include the whole week if the start date is a saturday" do
    one_week = WeeklyDummy.all_within(Date.new(2012, 8, 4), Date.new(2012, 8, 12)).first

    one_week.start_at.should == Date.new(2012, 7, 29)
    one_week.end_at.should == Date.new(2012, 8, 4)
  end

  it "should include the whole week if the start date is a wednesday" do
    one_week = WeeklyDummy.all_within(Date.new(2012, 8, 1), Date.new(2012, 8, 12)).first

    one_week.start_at.should == Date.new(2012, 7, 29)
    one_week.end_at.should == Date.new(2012, 8, 4)
  end


  it "should have multiple weeks for longer periods" do
    week_one, week_two = *WeeklyDummy.all_within(Date.new(2012, 8, 1), Date.new(2012, 8, 12))

    week_one.start_at.should == Date.new(2012, 7, 29)
    week_one.end_at.should == Date.new(2012, 8, 4)

    week_two.start_at.should == Date.new(2012, 8, 5)
    week_two.end_at.should == Date.new(2012, 8, 11)
  end

  it "should have a 6 week period on 2012-01-25 to 2012-03-04" do
    weeks = WeeklyDummy.all_within(Date.new(2012, 1, 25), Date.new(2012, 3, 4))

    weeks.should have(6).items

    weeks[0].start_at.should == Date.new(2012, 1, 22)
    weeks[1].start_at.should == Date.new(2012, 1, 29)
    weeks[2].start_at.should == Date.new(2012, 2, 5)
    weeks[3].start_at.should == Date.new(2012, 2, 12)
    weeks[4].start_at.should == Date.new(2012, 2, 19)
    weeks[5].start_at.should == Date.new(2012, 2, 26)
  end
end