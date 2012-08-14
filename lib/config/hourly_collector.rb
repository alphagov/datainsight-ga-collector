require_relative "../response/hourly_response"

module GoogleAnalytics
  module Config
    module HourlyCollector
      def self.included(base)
        base.extend(ClassMethods)
      end

      DIMENSION = "ga:hour"
      RESPONSE_TYPE = GoogleAnalytics::HourlyResponse

      module ClassMethods
        def last_before(reference_date)
          self.new(reference_date, reference_date)
        end

        def all_within(start_date, end_date)
          hourly_configs = []
          while start_date <= end_date
            hourly_configs << self.new(start_date, start_date)
            start_date += 1
          end
          hourly_configs
        end
      end
    end
  end
end