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
        google_analytics_id_list.map do |id|
          build_parameters_for(id: id)
        end
      end

      def build_parameters_for(config = {})
        parameters = {}

        parameters["ids"] = config[:id] || self.class::GOOGLE_ANALYTICS_URL_ID
        parameters["start-date"] = config[:start_at] || @start_at.strftime
        parameters["end-date"] = config[:end_at] || @end_at.strftime
        parameters["metrics"] = config[:metrics] || self.class::METRIC
        parameters["dimensions"] = config[:dimensions] || self.class::DIMENSION

        if config[:filters]
          parameters["filters"] = config[:filters]
        elsif defined?(self.class::FILTERS)
          parameters["filters"] = self.class::FILTERS
        end

        parameters
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

      private

      def google_analytics_id_list
        [*self.class::GOOGLE_ANALYTICS_URL_ID]
      end

    end
  end
end