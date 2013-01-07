require_relative "../../spec_helper"

describe "weekly entry/success response" do

  describe "when on a year boundary" do
    before(:each) do
      response_as_hash = load_json("weekly_transaction_response.json")
      @response = WeeklyTransactionResponse.new(response_as_hash, GoogleAnalytics::Config::WeeklyEntrySuccess)
    end

    it "should have an array of messages" do
      @response.messages.should be_an(Array)
    end
  end

end