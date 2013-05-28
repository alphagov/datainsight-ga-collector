require_relative "config/daily_collector"

module GoogleAnalytics
  module Config
    class DailyVisitors < Base
      include DailyCollector

      GOOGLE_ANALYTICS_URL_ID = GOVUK_PROFILE_ID
      METRIC='ga:visitors'
      AMQP_TOPIC='google_analytics.visitors.daily'
      SITE_KEY = "govuk"
    end
  end
end