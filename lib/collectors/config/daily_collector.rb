require_relative "../../response/daily_response"

module GoogleAnalytics
  module Config
    module DailyCollector
      def self.included(base)
        base.extend(ClassMethods)
      end

      DIMENSION = "ga:day"
      RESPONSE_TYPE = GoogleAnalytics::DailyResponse

      module ClassMethods
        def for(reference_date)
          self.new(reference_date,reference_date)
        end

        def all_within(start_date, end_date)
          daily_configs = []
          while start_date <= end_date
            daily_configs << self.for(start_date)
            start_date += 1
          end
          daily_configs.reverse
        end
      end
    end
  end
end