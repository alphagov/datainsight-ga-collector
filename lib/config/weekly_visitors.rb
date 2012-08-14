require_relative "base"
require_relative "weekly_collector"

module GoogleAnalytics
  module Config
    class WeeklyVisitors < Base
      include WeeklyCollector

      METRIC = "ga:visitors"
      AMQP_TOPIC = "google_analytics.visitors.weekly"
    end
  end
end

