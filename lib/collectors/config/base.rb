module GoogleAnalytics
  module Config
    class Base

      def self.descendants
        ObjectSpace.each_object(Class).select{|klass| klass < self }.map{|klass| klass.name.split("::").last}
      end

      def initialize start_at, end_at
        @start_at, @end_at = start_at, end_at
      end

      def analytics_parameters()
        parameters = {}

        parameters["ids"] = self.class::GOOGLE_ANALYTICS_URL_ID
        parameters["start-date"] = @start_at.strftime
        parameters["end-date"] = @end_at.strftime
        parameters["metrics"] = self.class::METRIC
        parameters["dimensions"] = self.class::DIMENSION
        parameters["filters"] = self.class::FILTERS if defined?(self.class::FILTERS)

        [parameters]
      end

      def amqp_topic
        self.class::AMQP_TOPIC
      end

      def response_type
        self.class::RESPONSE_TYPE
      end

      def to_s
         parameters = analytics_parameters
        "#{parameters["metrics"]}, #{parameters["dimensions"]} starting at: #{parameters["start-date"]}"
      end
    end
  end
end