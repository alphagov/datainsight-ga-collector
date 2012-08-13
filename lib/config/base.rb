module GoogleAnalytics
  module Config
    class Base
      def initialize reference_date
        @reference_date = reference_date
      end

      GOOGLE_ANALYTICS_URL_ID = "ga:53872948"
      DIMENSION = "ga:week"

      def analytics_parameters()
        last_week = DateRange::get_last_week(@reference_date)
        parameters = {}

        parameters["ids"] = self.class::GOOGLE_ANALYTICS_URL_ID
        parameters["start-date"] = last_week.first.strftime
        parameters["end-date"] = last_week.last.strftime
        parameters["metrics"] = self.class::METRIC
        parameters["dimensions"] = self.class::DIMENSION

        parameters
      end

      def amqp_topic
        self.class::AMQP_TOPIC
      end
    end
  end
end