require_relative "weekly_response"
require_relative "extract_weekly_dates"

module GoogleAnalytics
  class WeeklyTransactionResponse < BaseResponse
    include ExtractWeeklyDates

    def initialize(response_hash, config_class)
      @site = config_class::SITE_KEY
      @messages = create_messages(response_hash)
    end

    private

    def create_messages response_as_hash
      [create_message({
                        start_at: extract_start_at(response_as_hash["query"]["start-date"]),
                        end_at: extract_end_at(response_as_hash["query"]["end-date"]),
                        value: {
                          site: @site,
                          successes: extract_successes(response_as_hash["rows"])
                        }
                      })]
    end

    def extract_successes(rows)
      rows.map { |row| row[3].to_i }.reduce(:+)
    end

  end
end