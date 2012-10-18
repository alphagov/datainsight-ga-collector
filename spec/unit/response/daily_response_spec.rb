require_relative "../spec_helper"

include GoogleAnalytics

describe "Hourly Response" do

  describe "example from 2012-10-17 13:48:00+01:00"

  before(:all) do
    response_hash = load_json("daily_unique_visitors_response.json")
    @response = DailyResponse.new(response_hash)
  end

  it "should use visitors count" do
    @response.messages.should be_an(Array)
    @response.messages.should have(1).item
  end

  it "should have the daily visitors" do
    message = @response.messages[0]

    message[:payload][:start_at].should eql("2012-10-17T00:00:00+00:00")
    message[:payload][:end_at].should eql("2012-10-18T00:00:00+00:00")
    message[:payload][:value].should eql(909706)
    message[:payload][:site].should eql("govuk")
  end

end