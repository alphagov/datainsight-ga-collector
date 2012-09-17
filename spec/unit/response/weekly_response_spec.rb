require_relative "../spec_helper"

include GoogleAnalytics
describe "Weekly Response" do

  it "should use visits count if only one week is present (middle of the year)" do
    response_hash = load_json("weekly_visits_response.json")

    response = WeeklyResponse.new(response_hash)

    response.messages.should be_an(Array)
    response.messages.should have(1).item
    message = response.messages.first

    message[:payload][:start_at].should eql("2012-07-29T00:00:00+00:00")
    message[:payload][:end_at].should eql("2012-08-05T00:00:00+00:00")
    message[:payload][:value].should eql(32199)
    message[:payload][:site].should eql("govuk")
  end

  it "should add visits if two weeks are present (year switch)" do
    response_hash = load_json("weekly_visits_response_year_switch.json")

    response = WeeklyResponse.new(response_hash)

    response.messages.should be_an(Array)
    response.messages.should have(1).item
    message = response.messages.first

    message[:payload][:start_at].should eql("2010-12-26T00:00:00+00:00")
    message[:payload][:end_at].should eql("2011-01-02T00:00:00+00:00")
    message[:payload][:value].should eql(5000)
    message[:payload][:site].should eql("govuk")
  end

end