require_relative "base_response"
require_relative "extract_weekly_dates"

module GoogleAnalytics
  class WeeklyResponse < BaseResponse
    include ExtractWeeklyDates


    def initialize(response_hash, *ignore)
      @messages = [create_message(parse_success(response_hash))]
    end

    private
    def parse_success(response)
      {
          :start_at => extract_start_at(response["query"]["start-date"]),
          :end_at => extract_end_at(response["query"]["end-date"]),
          :value => get_total_metric(response["rows"]),
          :site => SITE_KEY
      }
    end


    def get_total_metric(rows)
      rows.inject(0) { |total, row| total + row.last.to_i }
    end
  end
end