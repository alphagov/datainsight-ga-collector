require_relative "../../spec_helper"

include GoogleAnalytics

describe "Weekly Content Engagement Response" do
  it "should handle the same slug across different formats" do
    ga_responses = [
        build_raw_ga_engagement_response(
            {format: "Format_1", slug: "slug"},
            {format: "Format_2", slug: "slug"},
        )
    ]

    response = WeeklyContentEngagementDetailResponse.new(ga_responses, DummyConfig)

    response.messages.should have(2).items
  end

  it "should create messages from multiple responses" do
    ga_responses = [
        build_raw_ga_engagement_response(
            {slug: "slug_01"},
            {slug: "slug_02"}
        ),
        build_raw_ga_engagement_response(
            {slug: "slug_03"},
            {slug: "slug_04"},
            {slug: "slug_05"}
        )
    ]

    response = WeeklyContentEngagementDetailResponse.new(ga_responses, DummyConfig)

    response.messages.should have(5).items
  end



  def build_raw_ga_response(*rows)
    {
        "query" => {
            "start-date" => DateTime.now.strftime,
            "end-date" => DateTime.now.strftime
        },
        "rows" => rows
    }
  end

  def build_raw_ga_engagement_response(*row_data)
    full_row_data = row_data.each.with_index(1).map do |d, index|
      [
          d[:week] || "02",
          d[:format] || "default_format",
          d[:slug] || "default_slug_#{index}",
          d[:event] || "default_event",
          d[:count] || rand(10000).to_s
      ]
    end

    build_raw_ga_response(*full_row_data)
  end
end