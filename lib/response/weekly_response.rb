require_relative "base_response"
require_relative "extract_weekly_dates"

module GoogleAnalytics
  class WeeklyResponse < BaseResponse
    include ExtractWeeklyDates


    def initialize(response, config_class)
      @site = config_class::SITE_KEY
      @metric = config_class::METRIC.split(":")[1].to_sym
      @messages = [create_message(parse_success(response.first))]
    end

    private
    def parse_success(response)
      rows = (response["rows"] or [])
      {
          :start_at => extract_start_at(response["query"]["start-date"]),
          :end_at => extract_end_at(response["query"]["end-date"]),
          :value => {
            @metric => get_total_metric(rows),
            :site => @site
          }
      }
    end


    def get_total_metric(rows)
      rows.inject(0) { |total, row| total + row.last.to_i }
    end
  end
end