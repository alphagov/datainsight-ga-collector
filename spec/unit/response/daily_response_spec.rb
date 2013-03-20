require_relative "../../spec_helper"

include GoogleAnalytics

describe "Daily Response" do

  class StubConfig
    METRIC='ga:dummy'
    SITE_KEY="govuk"
  end

  describe "example from 2012-10-17 13:48:00+01:00" do

    before(:all) do
      response_hash = load_json("daily_unique_visitors_response.json")
      @response = DailyResponse.new([response_hash], StubConfig)
    end

    it "should use visitors count" do
      @response.messages.should be_an(Array)
      @response.messages.should have(1).item
    end

    it "should have the daily visitors" do
      message = @response.messages[0]

      message[:payload].should == {
        start_at: "2012-10-17T01:00:00+01:00",
        end_at: "2012-10-18T01:00:00+01:00",
        value: {
          dummy: 909706,
          site: 'govuk'
        }
      }
    end
  end

  it "should convert date to local (London) timezone if required" do
    response_hash = load_json("daily_unique_visitors_response.json")
    response_hash["query"]["start-date"] = "2012-10-17T00:00:00+00:00"

    @response = DailyResponse.new([response_hash], StubConfig)
    message = @response.messages[0]

    message[:payload][:start_at].should == "2012-10-17T01:00:00+01:00"
  end
end