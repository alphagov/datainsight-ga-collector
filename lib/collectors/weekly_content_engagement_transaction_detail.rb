require_relative "../response/weekly_content_engagement_detail_response"

module GoogleAnalytics
  module Config
    class WeeklyContentEngagementTransactionDetail < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = %w(ga:53872948 ga:61976178)
      AMQP_TOPIC = "google_analytics.content_engagement.weekly"
      SITE_KEY = "govuk"

      DIMENSION = "ga:eventCategory,ga:eventAction,ga:eventLabel"
      METRIC = "ga:totalEvents"
      CATEGORY_PREFIX = "MS_"
      FILTERS= "ga:eventCategory==MS_transaction"
      RESPONSE_TYPE = GoogleAnalytics::WeeklyContentEngagementDetailResponse

      def analytics_parameters()
        self.class::GOOGLE_ANALYTICS_URL_ID.map do |id|
          build_parameters_for(id: id)
        end
      end
    end
  end
end