require_relative "config/base"
require_relative "config/weekly_collector"
require_relative "../response/insidegov_weekly_policy_entries_response"

module GoogleAnalytics
  module Config
    class InsideGovWeeklyPolicyEntries < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = "ga:53699180"
      AMQP_TOPIC = "google_analytics.insidegov.policy_entries.weekly"
      SITE_KEY = "insidegov"
      METRIC = "ga:totalEvents"
      DIMENSION = "ga:week,ga:eventAction"
      FILTERS = "ga:customVarValue2==policy;ga:eventLabel==Entry"
      RESPONSE_TYPE = GoogleAnalytics::InsideGovWeeklyPolicyEntriesResponse
    end
  end
end