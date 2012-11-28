require_relative "config/base"
require_relative "config/weekly_collector"
require_relative "../../lib/response/weekly_entry_success_response"

module GoogleAnalytics
  module Config
    class WeeklyEntrySuccess < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = "ga:53872948"
      AMQP_TOPIC = "google_analytics.entry_and_success.weekly"
      SITE_KEY = "govuk"

      DIMENSION = DIMENSION + ",ga:eventCategory,ga:eventLabel"
      METRIC = "ga:totalEvents"
      CATEGORY_PREFIX = 'MS_'
      FILTERS= "ga:eventCategory=~^#{CATEGORY_PREFIX}.*"
      RESPONSE_TYPE = GoogleAnalytics::WeeklyEntrySuccessResponse
    end
  end
end