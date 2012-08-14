require_relative "base_response"

module GoogleAnalytics
  class WeeklyResponse < BaseResponse


    def initialize(response_hash)
      @messages = []
      @messages << create_message(parse_success(response_hash))
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

    def extract_start_at(start_date)
      DateTime.parse(start_date).strftime
    end

    def extract_end_at(end_date)
      (DateTime.parse(end_date)+1).strftime
    end


    def get_total_metric(rows)
      rows.inject(0) { |total, row| total + row.last.to_i }
    end
  end
end