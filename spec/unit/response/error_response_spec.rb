require_relative "../spec_helper"

include GoogleAnalytics
describe "Error Response" do

  it "should have an error messag on error" do
    response = ErrorResponse.new(Exception.new "Bad Error!")

    response.messages.should be_an(Array)
    response.messages.should have(1).item
    message = response.messages.first

    message[:payload][:error].should eql("Bad Error!")

  end

end