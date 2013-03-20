require_relative "../../spec_helper"
require_relative "../../../lib/response/timezone_helper"

describe "timezone helper" do
  describe "to local timezone conversion" do
    it "should not convert if a date is not within summer time" do
      utc_date = DateTime.parse("2012-03-10T00:00:00+00:00")

      utc_date.to_local_timezone.should == DateTime.parse("2012-03-10T00:00:00+00:00")
    end

    it "should convert to BST if a date is within during summer time" do
      utc_date = DateTime.parse("2012-04-01T00:00:00+00:00")

      utc_date.to_local_timezone.should == DateTime.parse("2012-04-01T01:00:00+01:00")
    end

    it "should convert edge cases when the timezone change happens" do
      before_bst_change = DateTime.parse("2012-03-25T00:59:00+00:00")
      after_bst_change  = DateTime.parse("2012-03-25T01:01:00+00:00")

      before_bst_change.to_local_timezone.should == DateTime.parse("2012-03-25T00:59:00+00:00")
      after_bst_change.to_local_timezone.should == DateTime.parse("2012-03-25T02:01:00+01:00")
    end
  end
end