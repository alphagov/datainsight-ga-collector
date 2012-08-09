require "rspec"

require_relative "spec_helper"

describe "total visits" do

  it "should use visits count if only week is present (middle of the year)" do
    filename = "sample_response_from_ga.json"
    response_hash = JSON.parse(File.read(File.join(File.dirname(__FILE__), "../data", filename)))

    visit_response = VisitsResponse.create_from_success(response_hash)
    message = visit_response.message

    message[:payload][:week_starting].should eql("2012-07-29")
    message[:payload][:value].should eql(32199)
    message[:payload][:site].should eql("govuk")
  end

  it "should add visits if two weeks are present (year switch)" do
    filename = "sample_response_from_ga_year_switch.json"
    response_hash = JSON.parse(File.read(File.join(File.dirname(__FILE__), "../data", filename)))

    visit_response = VisitsResponse.create_from_success(response_hash)
    message = visit_response.message

    message[:payload][:week_starting].should eql("2010-12-26")
    message[:payload][:value].should eql(5000)
    message[:payload][:site].should eql("govuk")
  end

  it "should have an error messag on error" do
    visit_response = VisitsResponse.create_from_error_message("Bad Error!")
    message = visit_response.message

    message[:payload][:error].should eql("Bad Error!")

  end

end