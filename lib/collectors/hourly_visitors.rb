require_relative "config/base"
require_relative "config/hourly_collector"

module GoogleAnalytics
  module Config
    class HourlyVisitors < Base
      include HourlyCollector

      GOOGLE_ANALYTICS_URL_ID = "ga:53872948"
      METRIC = "ga:visitors"
      AMQP_TOPIC = "google_analytics.visitors.hourly"
      SITE_KEY = "govuk"
    end
  end
end

