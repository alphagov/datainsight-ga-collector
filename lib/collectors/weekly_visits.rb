require_relative "config/base"
require_relative "config/weekly_collector"

module GoogleAnalytics
  module Config
    class WeeklyVisits < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = GOVUK_PROFILE_ID
      METRIC = "ga:visits"
      AMQP_TOPIC = 'google_analytics.visits.weekly'
      SITE_KEY = "govuk"
    end
  end
end