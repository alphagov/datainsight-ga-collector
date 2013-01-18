require_relative "../../spec_helper"

include GoogleAnalytics

describe "Weekly Content Engagement Response" do
  describe "condense_to_one_week" do
    it "should handle the same slug across different formats" do
      ga_response = [{
                       "query" => {
                         "start-date" => DateTime.now.strftime,
                         "end-date" => DateTime.now.strftime
                       },
                       "rows" => [
                         ["02", "Format_1", "slug", "Entry", "9752"],
                         ["02", "Format_2", "slug", "Entry", "9752"],
                       ] }]
      response = WeeklyContentEngagementDetailResponse.new(ga_response, DummyConfig)

      response.messages.should have(2).items
    end
  end
end