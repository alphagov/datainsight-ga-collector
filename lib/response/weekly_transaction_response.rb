require_relative "weekly_response"
require_relative "extract_weekly_dates"

module GoogleAnalytics
  class WeeklyTransactionResponse < BaseResponse
    include ExtractWeeklyDates

    def initialize(response_hash, config_class)
      @messages = []
    end


  end
end