require "rspec"

require_relative "spec_helper"

describe "Date Range" do

  it "should create a range for the last week" do
    a_thursday = Date.new(2012, 8, 9)
    last_week = DateRange::get_last_week(a_thursday)

    last_week.first.should eql(Date.new(2012, 7, 29))
    last_week.last.should eql(Date.new(2012, 8, 4))
  end

  it "should go back to last saturday, if passed date is a saturday" do
    a_saturday = Date.new(2012, 3, 17)
    last_week = DateRange::get_last_week(a_saturday)

    last_week.first.should eql(Date.new(2012, 3, 4))
    last_week.last.should eql(Date.new(2012, 3, 10))
  end
end