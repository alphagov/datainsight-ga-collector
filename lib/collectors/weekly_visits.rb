require_relative "config/base"
require_relative "config/weekly_collector"

module GoogleAnalytics
  module Config
    class WeeklyVisits < Base
      include WeeklyCollector

      METRIC = "ga:visits"
      AMQP_TOPIC = 'google_analytics.visits.weekly'
    end
  end
end