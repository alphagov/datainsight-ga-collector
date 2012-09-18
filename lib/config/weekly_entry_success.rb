require_relative "base"
require_relative "weekly_collector"
require_relative "../../lib/response/weekly_entry_success_response"

module GoogleAnalytics
  module Config
    class WeeklyEntrySuccess < Base
      include WeeklyCollector

      AMQP_TOPIC = "google_analytics.entry_and_success.weekly"

      DIMENSION = DIMENSION + ",ga:eventCategory,ga:eventLabel"
      METRIC = "ga:totalEvents"
      CATEGORY_PREFIX = 'MS_'
      FILTERS= "ga:eventCategory=~^#{CATEGORY_PREFIX}.*"
      RESPONSE_TYPE = GoogleAnalytics::WeeklyEntrySuccessResponse
    end
  end
end