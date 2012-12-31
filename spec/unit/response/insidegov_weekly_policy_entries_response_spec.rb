require_relative "../../spec_helper"

include GoogleAnalytics
describe "insidegov weekly policy entries response" do

  def message_for_format format
    @response.messages.find do |msg|
      msg[:payload][:value][:format] == format
    end
  end

  describe "result within the same year" do
    before(:each) do
      response_as_hash = load_json("insidegov_weekly_policy_entries_response.json")
      @response = InsideGovWeeklyPolicyEntriesResponse.new(response_as_hash, GoogleAnalytics::Config::InsideGovWeeklyPolicyEntries)
    end

    it "should have an array of messages" do
      @response.messages.should be_an(Array)
      @response.messages.should have(5).items
    end

    it "should have an envelope and a payload" do
      first_message = @response.messages.first
      envelope = first_message[:envelope]
      envelope.should be_a(Hash)
      envelope[:collected_at].should be_a(DateTime)
      envelope[:collector].should == "Google Analytics"
      first_message[:payload].should be_a(Hash)
    end

    it "should have start_at, end_at and site data" do
      message_payload = @response.messages.first[:payload]
      message_payload[:start_at].should == "2012-11-25T00:00:00+00:00"
      message_payload[:end_at].should == "2012-12-02T00:00:00+00:00"
      message_payload[:value][:site].should == "insidegov"
    end

    it "should have entries for policies" do
      message_payload_value = @response.messages.first[:payload][:value]
      message_payload_value[:entries].should == 12
    end

    it "should have slugs for policies" do
      message_payload_value = @response.messages.first[:payload][:value]
      message_payload_value[:slug].should == "apply-for-tax-disc-refund-form-v14"
    end
  end

  describe "when crossing year boundary" do
    before(:each) do
      response_as_hash = load_json("insidegov_weekly_policy_entries_response_year_boundary.json")
      @response = InsideGovWeeklyPolicyEntriesResponse.new(response_as_hash, GoogleAnalytics::Config::InsideGovWeeklyPolicyEntries)
    end

    it "should have an array of messages" do
      @response.messages.should be_an(Array)
      @response.messages.should have(5).items
    end

    it "should have an envelope and a payload"

    it "should have start_at, end_at and site data"

    it "should have entries for policies"

    it "should have slugs for policies"
  end

  describe "response with no results" do
    before(:each) do
      response_as_hash = load_json("insidegov_weekly_policy_entries_response_no_results.json")
      @response = InsideGovWeeklyPolicyEntriesResponse.new(response_as_hash, GoogleAnalytics::Config::InsideGovWeeklyPolicyEntries)
    end

    it "should send no messages" do
      @response.messages.should be_an(Array)
      @response.messages.should be_empty
    end
  end
end