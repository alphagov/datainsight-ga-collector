require_relative "../../spec_helper"

include GoogleAnalytics
describe "Weekly Response" do

  it "should convert date to local (London) timezone if required" do
    response_hash = load_json("weekly_dummy_response.json")
    response_hash["query"]["start-date"] = "2012-10-17T00:00:00+00:00"

    @response = WeeklyResponse.new([response_hash], StubConfig)
    message = @response.messages[0]

    message[:payload][:start_at].should == "2012-10-17T01:00:00+01:00"
  end

  describe "example when the DST timezone change happens" do
    it "should have use datetimes with correct timezones" do
      response_hash = load_json("weekly_dummy_response.json")
      response_hash["query"]["start-date"] = "2012-03-25T00:00:00+00:00"
      response_hash["query"]["end-date"] = "2012-03-31T00:00:00+00:00"

      response = WeeklyResponse.new([response_hash], DummyConfig)
      message = response.messages.first

      message[:payload][:start_at].should eql("2012-03-25T00:00:00+00:00")
      message[:payload][:end_at].should eql("2012-04-01T01:00:00+01:00")
    end
  end

  it "should use dummy count if only one week is present (middle of the year)" do
    response_hash = load_json("weekly_dummy_response.json")

    response = WeeklyResponse.new([response_hash], DummyConfig)

    response.messages.should be_an(Array)
    response.messages.should have(1).item
    message = response.messages.first

    message[:payload][:start_at].should eql("2012-01-29T00:00:00+00:00")
    message[:payload][:end_at].should eql("2012-02-05T00:00:00+00:00")
    message[:payload][:value][:dummy].should eql(32199)
    message[:payload][:value][:site].should eql("govuk")
  end

  it "should report 0 when no results have been provided" do
    response_hash = load_json("weekly_dummy_response_no_results.json")

    response = WeeklyResponse.new([response_hash], DummyConfig)
    response.messages.should have(1).item
    message = response.messages.first

    message[:payload][:start_at].should eql("2012-01-29T00:00:00+00:00")
    message[:payload][:end_at].should eql("2012-02-05T00:00:00+00:00")
    message[:payload][:value][:dummy].should eql(0)
    message[:payload][:value][:site].should eql("govuk")
  end
end