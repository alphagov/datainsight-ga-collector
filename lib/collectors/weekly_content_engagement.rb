require_relative "config/base"
require_relative "config/weekly_collector"
require_relative "../../lib/response/weekly_content_engagement_response"

module GoogleAnalytics
  module Config
    class WeeklyContentEngagement < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = GOVUK_PROFILE_ID
      AMQP_TOPIC = "google_analytics.entry_and_success.weekly"
      SITE_KEY = "govuk"

      DIMENSION = "ga:eventCategory,ga:eventLabel"
      METRIC = "ga:totalEvents"
      CATEGORY_PREFIX = 'MS_'
      FILTERS= "ga:eventCategory=~^#{CATEGORY_PREFIX}.*;ga:eventCategory!=MS_transaction"
      RESPONSE_TYPE = GoogleAnalytics::WeeklyContentEngagementResponse
    end
  end
end