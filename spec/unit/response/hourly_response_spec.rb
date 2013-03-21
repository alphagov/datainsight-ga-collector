require_relative "../../spec_helper"

include GoogleAnalytics

describe "Hourly Response" do

  it "should convert date to local (London) timezone if required" do
    response_hash = load_json("hourly_unique_visitors_response.json")
    response_hash["query"]["start-date"] = "2012-10-17T00:00:00+00:00"

    @response = HourlyResponse.new([response_hash], StubConfig)
    message = @response.messages[0]

    message[:payload][:start_at].should == "2012-10-17T00:00:00+01:00"
  end

  describe "example from 2012-03-25 when the DST timezone change happens" do
    before(:each) do
      response_hash = load_json("hourly_unique_visitors_response.json")
      response_hash["query"]["start-date"] = "2012-03-25T00:00:00+00:00"
      @response = HourlyResponse.new([response_hash], DummyConfig)
    end

    it "should contain the first hour" do
      message = @response.messages[0]

      message[:payload][:start_at].should eql("2012-03-25T00:00:00+00:00")
      message[:payload][:end_at].should eql("2012-03-25T01:00:00+01:00")
      message[:payload][:value][:dummy].should eql(75)
      message[:payload][:value][:site].should eql("govuk")
    end

    it "should contain the tenth hour" do
      message = @response.messages[10]

      message[:payload][:start_at].should eql("2012-03-25T10:00:00+01:00")
      message[:payload][:end_at].should eql("2012-03-25T11:00:00+01:00")
      message[:payload][:value][:dummy].should eql(429)
      message[:payload][:value][:site].should eql("govuk")
    end

    it "should contain the last hour" do
      message = @response.messages[23]

      message[:payload][:start_at].should eql("2012-03-25T23:00:00+01:00")
      message[:payload][:end_at].should eql("2012-03-26T00:00:00+01:00")
      message[:payload][:value][:dummy].should eql(0)
      message[:payload][:value][:site].should eql("govuk")
    end
  end

  describe "example from 2012-02-14" do
    before(:each) do
      response_hash = load_json("hourly_unique_visitors_response.json")
      @response = HourlyResponse.new([response_hash], DummyConfig)
    end

    it "should use dummy count if only week is present (middle of the year)" do
      @response.messages.should be_an(Array)
      @response.messages.should have(24).item
    end

    it "should check the first hour" do
      message = @response.messages[0]

      message[:payload][:start_at].should eql("2012-02-14T00:00:00+00:00")
      message[:payload][:end_at].should eql("2012-02-14T01:00:00+00:00")
      message[:payload][:value][:dummy].should eql(75)
      message[:payload][:value][:site].should eql("govuk")
    end

    it "should check the tenth hour" do
      message = @response.messages[10]

      message[:payload][:start_at].should eql("2012-02-14T10:00:00+00:00")
      message[:payload][:end_at].should eql("2012-02-14T11:00:00+00:00")
      message[:payload][:value][:dummy].should eql(429)
      message[:payload][:value][:site].should eql("govuk")
    end

    it "should check the last hour" do
      message = @response.messages[23]

      message[:payload][:start_at].should eql("2012-02-14T23:00:00+00:00")
      message[:payload][:end_at].should eql("2012-02-15T00:00:00+00:00")
      message[:payload][:value][:dummy].should eql(0)
      message[:payload][:value][:site].should eql("govuk")
    end
  end


  describe "response with no results" do
    before(:all) do
      response_hash = load_json("hourly_unique_visitors_response_no_results.json")
      @response = HourlyResponse.new([response_hash], DummyConfig)
    end

    it "should create no messages" do
      @response.messages.should be_an(Array)
      @response.messages.should be_empty
    end
  end


end