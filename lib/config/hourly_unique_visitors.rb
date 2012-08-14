require_relative "base"
require_relative "hourly_collector"

module GoogleAnalytics
  module Config
    class HourlyUniqueVisitors < Base
      include HourlyCollector

      METRIC = "ga:visitors"
      AMQP_TOPIC = "google_analytics.unique_visitors.hourly"
    end
  end
end

