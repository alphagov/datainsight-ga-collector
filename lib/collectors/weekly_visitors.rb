require_relative "config/base"
require_relative "config/weekly_collector"

module GoogleAnalytics
  module Config
    class WeeklyVisitors < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = GOVUK_PROFILE_ID
      METRIC = "ga:visitors"
      AMQP_TOPIC = "google_analytics.visitors.weekly"
      SITE_KEY = "govuk"
    end
  end
end

