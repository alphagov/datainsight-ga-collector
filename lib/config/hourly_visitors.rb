require_relative "base"
require_relative "hourly_collector"

module GoogleAnalytics
  module Config
    class HourlyVisitors < Base
      include HourlyCollector

      METRIC = "ga:visitors"
      AMQP_TOPIC = "google_analytics.visitors.hourly"
    end
  end
end

