require_relative "../../spec_helper"

describe "weekly entry/success response" do

  describe "when on a year boundary" do
    before(:each) do
      response_as_hash = load_json("weekly_transaction_response.json")
      @response = WeeklyTransactionResponse.new([response_as_hash], GoogleAnalytics::Config::WeeklyEntrySuccess)
    end

    it "should have an array of messages" do
      @response.messages.should be_an(Array)
      @response.messages.should have(1).message
    end

    it "should have an envelope and payload" do
      @response.messages.first[:envelope].should be_a(Hash)
      @response.messages.first[:envelope][:collected_at].should be_a(DateTime)
      @response.messages.first[:envelope][:collector].should == "Google Analytics"
      @response.messages.first[:payload].should be_a(Hash)
    end

    it "should have start at, end at and site data in the payload" do
      payload = @response.messages.first[:payload]
      payload[:start_at].should == "2012-12-30T00:00:00+00:00"
      payload[:end_at].should == "2013-01-06T00:00:00+00:00"
      payload[:value][:site].should == "govuk"
    end

    it "should have successes for transactions" do
      payload = @response.messages.first[:payload]
      payload[:value][:successes].should == 1431421
    end

    it "should have format set to transaction in payload" do
      @response.messages.first[:payload][:value][:format].should == "transaction"
    end
  end

end