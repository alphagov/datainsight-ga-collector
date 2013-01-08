require_relative "config/base"
require_relative "config/weekly_collector"
require_relative "../../lib/response/weekly_transaction_response"

module GoogleAnalytics
  module Config
    class WeeklyTransaction < Base
      include WeeklyCollector

      GOOGLE_ANALYTICS_URL_ID = %w(ga:53872948 ga:61976178)
      AMQP_TOPIC = "google_analytics.entry_and_success.weekly"
      SITE_KEY = "govuk"

      DIMENSION = DIMENSION + ",ga:eventCategory,ga:eventLabel"
      METRIC = "ga:totalEvents"
      CATEGORY_PREFIX = 'MS_'
      FILTERS = "ga:eventCategory==MS_transaction"
      RESPONSE_TYPE = GoogleAnalytics::WeeklyTransactionResponse

      def analytics_parameters()
        self.class::GOOGLE_ANALYTICS_URL_ID.map do |id|
          build_parameters_for(id)
        end
      end

      def build_parameters_for(id)
        parameters = {}

        parameters["ids"] = id
        parameters["start-date"] = @start_at.strftime
        parameters["end-date"] = @end_at.strftime
        parameters["metrics"] = self.class::METRIC
        parameters["dimensions"] = self.class::DIMENSION
        parameters["filters"] = self.class::FILTERS if defined?(self.class::FILTERS)
        
        parameters
      end
    end
  end
end
