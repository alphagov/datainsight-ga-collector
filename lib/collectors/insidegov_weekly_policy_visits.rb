require_relative "config/base"
require_relative "config/weekly_collector"

module GoogleAnalytics
  module Config
    class InsideGovWeeklyPolicyVisits < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = "ga:??"
      METRIC = "ga:visits"
      AMQP_TOPIC = "google_analytics.insidegov.policy_visits.weekly"
      SITE_KEY = "insidegov"
    end
  end
end