require_relative "../spec_helper"

describe "Weekly Entry and Success Event Collection" do

  let(:monday_13th_of_august) {"2012-08-13"}
  let(:saturday_11th_of_august) {"2012-08-11"}
  let(:sunday_05th_of_august) {"2012-08-05"}

  before(:all) do
    @configs = GoogleAnalytics::Config::WeeklyEntrySuccess.last_before(Date.parse(monday_13th_of_august))
  end

  it "should have an amqp_topic of google_analytics.entry_and_success.weekly" do
    @configs.amqp_topic.should == "google_analytics.entry_and_success.weekly"
  end

  it "should have a response type of weekly event" do
    @configs.response_type.should eql(GoogleAnalytics::WeeklyEventResponse)
  end

  describe "analytics_parameters" do
    before(:all) do
      @p = @configs.analytics_parameters
    end

    it "should have google analytics ids" do
      @p["ids"].should == "ga:53872948"
    end

    it "should have a start date of the sunday 7 days of more before" do
      @p["start-date"].should == sunday_05th_of_august
    end

    it "should have a end date of saturday before the given date" do
      @p["end-date"].should == saturday_11th_of_august
    end

    it "should have a totalEvents metric" do
      @p["metrics"].should == "ga:totalEvents"
    end

    it "should have week, event category and event label dimensions" do
      @p["dimensions"].should == "ga:week,ga:eventCategory,ga:eventLabel"
    end

    it "should have a filter to track MS_* events" do
      @p["filters"].should == "ga:eventCategory=~^MS_.*"
    end

  end

end