require_relative "base"
require_relative "weekly_collector"

module GoogleAnalytics
  module Config
    class WeeklyVisits < Base
      include WeeklyCollector

      METRIC = "ga:visits"
      AMQP_TOPIC = 'google_analytics.visits.weekly'
    end
  end
end