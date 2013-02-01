require_relative "config/base"
require_relative "config/weekly_collector"
require_relative "../../lib/response/weekly_content_engagement_response"

module GoogleAnalytics
  module Config
    class InsideGovWeeklyContentEngagement < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = "ga:53872948"
      AMQP_TOPIC = "google_analytics.insidegov.entry_and_success.weekly"
      SITE_KEY = "insidegov"

      DIMENSION = "ga:eventCategory,ga:eventLabel"
      METRIC = "ga:totalEvents"
      CATEGORY_PREFIX = 'IG_'
      FILTERS= "ga:eventCategory=~^#{CATEGORY_PREFIX}.*"
      RESPONSE_TYPE = GoogleAnalytics::WeeklyContentEngagementResponse
    end
  end
end