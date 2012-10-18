require_relative "../spec_helper"

include GoogleAnalytics

describe "Hourly Response" do

  describe "example from 2012-08-14 12:07:00+01:00"

  before(:all) do
    response_hash = load_json("hourly_unique_visitors_response.json")
    @response = HourlyResponse.new(response_hash, DummyConfig)
  end

  it "should use dummy count if only week is present (middle of the year)" do
    @response.messages.should be_an(Array)
    @response.messages.should have(24).item
  end

  it "should check the first hour" do
    message = @response.messages[0]

    message[:payload][:start_at].should eql("2012-08-14T00:00:00+00:00")
    message[:payload][:end_at].should eql("2012-08-14T01:00:00+00:00")
    message[:payload][:value][:dummy].should eql(75)
    message[:payload][:value][:site].should eql("govuk")
  end

  it "should check the tenth hour" do
    message = @response.messages[10]

    message[:payload][:start_at].should eql("2012-08-14T10:00:00+00:00")
    message[:payload][:end_at].should eql("2012-08-14T11:00:00+00:00")
    message[:payload][:value][:dummy].should eql(429)
    message[:payload][:value][:site].should eql("govuk")
  end

  it "should check the last hour" do
    message = @response.messages[23]

    message[:payload][:start_at].should eql("2012-08-14T23:00:00+00:00")
    message[:payload][:end_at].should eql("2012-08-15T00:00:00+00:00")
    message[:payload][:value][:dummy].should eql(0)
    message[:payload][:value][:site].should eql("govuk")
  end

end