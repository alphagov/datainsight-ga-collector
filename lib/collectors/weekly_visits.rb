require_relative "config/base"
require_relative "config/weekly_collector"

module GoogleAnalytics
  module Config
    class WeeklyVisits < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = "ga:53872948"
      METRIC = "ga:visits"
      AMQP_TOPIC = 'google_analytics.visits.weekly'
      SITE_KEY = "govuk"
    end
  end
end