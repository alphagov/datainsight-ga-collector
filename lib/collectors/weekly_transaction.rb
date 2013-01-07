require_relative "config/base"
require_relative "config/weekly_collector"

module GoogleAnalytics
  module Config
    class WeeklyTransaction < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = "ga:61976178"
      AMQP_TOPIC = "google_analytics.entry_and_success.weekly"

      DIMENSION = DIMENSION + ",ga:eventCategory,ga:eventLabel"
      METRIC = "ga:totalEvents"
      CATEGORY_PREFIX = 'MS_'
      FILTERS = "ga:eventCategory==MS_transaction"
      RESPONSE_TYPE = nil

    end
  end
end