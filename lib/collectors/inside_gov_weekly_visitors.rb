module GoogleAnalytics
  module Config
    class InsideGovWeeklyVisitors < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = "ga:53699180"
      METRIC = "ga:visitors"
      AMQP_TOPIC = "inside_gov.google_analytics.visitors.weekly"
      SITE_KEY = "insidegov"
    end
  end
end
