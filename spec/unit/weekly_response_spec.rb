require_relative "spec_helper"

include GoogleAnalytics
describe "Weekly Response" do

  it "should use visits count if only week is present (middle of the year)" do
    filename = "sample_response_from_ga.json"
    response_hash = JSON.parse(File.read(File.join(File.dirname(__FILE__), "../data", filename)))

    responses = WeeklyResponse.create_from_success(response_hash)
    responses.should be_an(Array)
    responses.should have(1).item
    message = responses.first.message

    message[:payload][:start_at].should eql("2012-07-29T00:00:00+00:00")
    message[:payload][:end_at].should eql("2012-08-05T00:00:00+00:00")
    message[:payload][:value].should eql(32199)
    message[:payload][:site].should eql("govuk")
  end

  it "should add visits if two weeks are present (year switch)" do
    filename = "sample_response_from_ga_year_switch.json"
    response_hash = JSON.parse(File.read(File.join(File.dirname(__FILE__), "../data", filename)))

    responses = WeeklyResponse.create_from_success(response_hash)
    responses.should be_an(Array)
    responses.should have(1).item
    message = responses.first.message

    message[:payload][:start_at].should eql("2010-12-26T00:00:00+00:00")
    message[:payload][:end_at].should eql("2011-01-02T00:00:00+00:00")
    message[:payload][:value].should eql(5000)
    message[:payload][:site].should eql("govuk")
  end

  it "should have an error messag on error" do
    responses = WeeklyResponse.create_from_error_message("Bad Error!")
    responses.should be_an(Array)
    responses.should have(1).item
    message = responses.first.message

    message[:payload][:error].should eql("Bad Error!")

  end

end