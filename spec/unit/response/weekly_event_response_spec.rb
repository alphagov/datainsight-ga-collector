require_relative "../../unit/spec_helper"

include GoogleAnalytics
describe "weekly event response" do
  describe "without year switch" do

    before(:each) do
      response_as_hash = load_json("weekly_event_success_response.json")
      @response = WeeklyEventResponse.new(response_as_hash)
    end

    it "should have an array of messages" do
      @response.messages.should be_an(Array)
      @response.messages.should have(14).items
    end

    it "should be have an envelope and a payload" do
      @response.messages.first[:envelope].should be_a(Hash)
      @response.messages.first[:envelope][:collected_at].should be_a(DateTime)
      @response.messages.first[:envelope][:collector].should eql("Google Analytics")
      @response.messages.first[:payload].should be_a(Hash)
    end

    it "should have start_at, end_at, value, site, format and action data" do
      first_message_content = @response.messages.first[:payload]
      first_message_content[:start_at].should eql("2012-09-09T00:00:00+00:00")
      first_message_content[:end_at].should eql("2012-09-16T00:00:00+00:00")
      first_message_content[:value].should eql(8939)
      first_message_content[:site].should eql("govuk")
      first_message_content[:format].should eql("MS_answer")
      first_message_content[:action].should eql("Entry")
    end
  end

  describe "with year switch" do
    before(:each) do
      response_as_hash = load_json("weekly_event_success_response_year_switch.json")
      @response = WeeklyEventResponse.new(response_as_hash)
    end

    it "should have an array of messages" do
      @response.messages.should be_an(Array)
      @response.messages.should have(14).items
    end

    it "should be have an envelope and a payload" do
      @response.messages.first[:envelope].should be_a(Hash)
      @response.messages.first[:envelope][:collected_at].should be_a(DateTime)
      @response.messages.first[:envelope][:collector].should eql("Google Analytics")
      @response.messages.first[:payload].should be_a(Hash)
    end

    it "should have start_at, end_at, value, site, format and action data" do
      first_message_content = @response.messages.first[:payload]
      first_message_content[:start_at].should eql("2012-09-09T00:00:00+00:00")
      first_message_content[:end_at].should eql("2012-09-16T00:00:00+00:00")
      first_message_content[:site].should eql("govuk")
      first_message_content[:format].should eql("MS_answer")
      first_message_content[:action].should eql("Entry")
    end

    it "should sum up the values of the two data" do
      first_message_content = @response.messages.first[:payload]
      first_message_content[:value].should eql(2*8939)
    end
  end

end