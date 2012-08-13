require_relative "base"
require_relative "weekly_collector"

module GoogleAnalytics
  module Config
    class WeeklyUniqueVisitors < Base
      include WeeklyCollector

      METRIC = "ga:visitors"
      AMQP_TOPIC = "google_analytics.unique_visitors.weekly"
    end
  end
end

