require_relative "base"
require_relative "weekly_collector"
require_relative "../../lib/response/weekly_event_response"

module GoogleAnalytics
  module Config
    class WeeklyEntrySuccess < Base
      include WeeklyCollector

      AMQP_TOPIC = "google_analytics.entry_and_success.weekly"

      DIMENSION = DIMENSION + ",ga:eventCategory,ga:eventLabel"
      METRIC = "ga:totalEvents"
      FILTERS= "ga:eventCategory=~^MS_.*"
      RESPONSE_TYPE = GoogleAnalytics::WeeklyEventResponse
    end
  end
end