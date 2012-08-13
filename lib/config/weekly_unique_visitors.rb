require_relative "base"

module GoogleAnalytics
  module Config
    class WeeklyUniqueVisitors < Base
      METRIC = "ga:visitors"
      AMQP_TOPIC = "google_analytics.unique_visitors.weekly"
    end
  end
end

