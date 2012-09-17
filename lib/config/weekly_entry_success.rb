require_relative "base"
require_relative "weekly_collector"

module GoogleAnalytics
  module Config
    class WeeklyEntrySuccess < Base
      include WeeklyCollector

      AMQP_TOPIC = "google_analytics.entry_and_success.weekly"

      DIMENSION = DIMENSION + ",ga:eventCategory,ga:eventLabel"
      METRIC = "ga:totalEvents"
      FILTERS= "ga:eventCategory=~^MS_.*"
    end
  end
end