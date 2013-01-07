require_relative "../../spec_helper"

describe "Weekly transaction event collection" do

  let(:monday_7th_of_january) {"2013-01-07"}
  let(:sunday_30th_of_december) {"2012-12-30"}
  let(:saturday_5th_of_january) {"2013-01-05"}

  before(:all) do
    @configs = GoogleAnalytics::Config::WeeklyTransaction.last_before(Date.parse(monday_7th_of_january))
  end

  it "should have an amqp_topic of google_analytics.transation.weekly" do
    @configs.amqp_topic.should == "google_analytics.entry_and_success.weekly"
  end

  it "should have a response type of weekly transaction"

  describe "analytics_parameters" do
    before(:all) do
      @parameters = @configs.analytics_parameters
    end

    it "should have google analytics ids" do
      @parameters["ids"].should == "ga:61976178"
    end

    it "should have a start date on a Sunday a week or more prior to the given date" do
      @parameters["start-date"].should == sunday_30th_of_december
    end

    it "should have a have an end date equal to the Saturday prior to the given date" do
      @parameters["end-date"].should == saturday_5th_of_january
    end

    it "should have a totalEvents metric" do
      @parameters["metrics"].should == "ga:totalEvents"
    end

    it "should have week, event category and event label dimensions" do
      @parameters["dimensions"].should == "ga:week,ga:eventCategory,ga:eventLabel"
    end

    it "should filter for MS_transaction" do
      @parameters["filters"].should == "ga:eventCategory==MS_transaction"
    end

  end

end