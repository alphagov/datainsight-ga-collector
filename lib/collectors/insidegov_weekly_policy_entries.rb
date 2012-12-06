require_relative "config/base"
require_relative "config/weekly_collector"

module GoogleAnalytics
  module Config
    class InsideGovWeeklyPolicyEntries < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = "ga:53699180"
      AMQP_TOPIC = "google_analytics.insidegov.policy_entries.weekly"
      SITE_KEY = "insidegov"
      METRIC = "ga:totalEvents"
      DIMENSION = "ga:eventAction,ga:week"
      FILTERS = "ga:customVarValue2==policy;ga:eventLabel==Entry"
    end
  end
end