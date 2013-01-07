require_relative "../../spec_helper"

include "weekly entry/success reponse" do

  it "should have an array of messages" do
    @response.messages.should be_an(Array)
  end

end