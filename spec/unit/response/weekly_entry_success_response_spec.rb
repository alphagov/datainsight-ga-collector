require_relative "../../unit/spec_helper"

include GoogleAnalytics
describe "weekly entry/success response" do

  def message_for_format format
    @response.messages.find do |msg|
      msg[:payload][:format] == format
    end
  end

  describe "without year switch" do

    before(:each) do
      response_as_hash = load_json("weekly_entry_success_response.json")
      @response = WeeklyEntrySuccessResponse.new(response_as_hash, GoogleAnalytics::Config::WeeklyEntrySuccess)
    end

    it "should have an array of messages" do
      @response.messages.should be_an(Array)
      @response.messages.should have(13).items
    end

    it "should be have an envelope and a payload" do
      @response.messages.first[:envelope].should be_a(Hash)
      @response.messages.first[:envelope][:collected_at].should be_a(DateTime)
      @response.messages.first[:envelope][:collector].should eql("Google Analytics")
      @response.messages.first[:payload].should be_a(Hash)
    end

    it "should have start_at, end_at and site data" do
      message_payload = @response.messages.first[:payload]
      message_payload[:start_at].should eql("2012-09-09T00:00:00+00:00")
      message_payload[:end_at].should eql("2012-09-16T00:00:00+00:00")
      message_payload[:site].should eql("govuk")
    end

    it "should have entries and successes for guide" do
      # There are no success events on answer
      message_payload = message_for_format("guide")[:payload]
      message_payload[:entries].should eql(11882)
      message_payload[:successes].should eql(10148)
    end

    it "should have entries and 0 successes for answer" do
      message_payload = message_for_format("answer")[:payload]
      message_payload[:entries].should eql(8939)
      message_payload[:successes].should eql(0)
    end

  end

  describe "with year switch" do
    before(:each) do
      response_as_hash = load_json("weekly_entry_success_response_year_switch.json")
      @response = WeeklyEntrySuccessResponse.new(response_as_hash, GoogleAnalytics::Config::WeeklyEntrySuccess)
    end

    it "should have an array of messages" do
      @response.messages.should be_an(Array)
      @response.messages.should have(13).items
    end

    it "should be have an envelope and a payload" do
      @response.messages.first[:envelope].should be_a(Hash)
      @response.messages.first[:envelope][:collected_at].should be_a(DateTime)
      @response.messages.first[:envelope][:collector].should eql("Google Analytics")
      @response.messages.first[:payload].should be_a(Hash)
    end

    it "should have start_at, end_at and site data" do
      message_payload = @response.messages.first[:payload]
      message_payload[:start_at].should eql("2012-09-09T00:00:00+00:00")
      message_payload[:end_at].should eql("2012-09-16T00:00:00+00:00")
      message_payload[:site].should eql("govuk")
    end

    it "should have entries and successes for guide" do
      # There are no success events on answer
      message_payload = message_for_format("guide")[:payload]
      message_payload[:entries].should eql(2*11882)
      message_payload[:successes].should eql(2*10148)
    end

    it "should have entries and 0 successes for answer" do
      message_payload = message_for_format("answer")[:payload]
      message_payload[:entries].should eql(2*8939)
      message_payload[:successes].should eql(0)
    end
  end

end