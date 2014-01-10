# NOTE: This has been re-implemented in the backdrop-ga-collector
# (https://github.com/alphagov/backdrop-ga-collector)
# - see the config at https://github.gds/gds/pp-deployment/pull/77

module GoogleAnalytics
  module Config
    class InsideGovWeeklyVisitors < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = INSIDEGOV_PROFILE_ID
      METRIC = "ga:visitors"
      AMQP_TOPIC = "google_analytics.inside_gov.visitors.weekly"
      SITE_KEY = "insidegov"
    end
  end
end
