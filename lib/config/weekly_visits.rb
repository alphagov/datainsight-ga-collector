require_relative "base"

module GoogleAnalytics
  module Config
    class WeeklyVisits < Base
      METRIC = "ga:visits"
      AMQP_TOPIC = 'google_analytics.visits.weekly'
    end
  end
end