require_relative "config/daily_collector"

module GoogleAnalytics
  module Config
    class DailyVisitors < Base
      include DailyCollector

      AMQP_TOPIC='google_analytics.visitors.daily'
      METRIC='ga:visitors'
    end
  end
end