require_relative "../../response/weekly_response"

module GoogleAnalytics
  module Config
    module WeeklyCollector

      def self.included(base)
        base.extend(ClassMethods)
      end

      DIMENSION = ""
      RESPONSE_TYPE = GoogleAnalytics::WeeklyResponse

      module ClassMethods
        def last_before(reference_date)
          last_saturday = saturday_before(reference_date)
          sunday_before_saturday = last_saturday - 6
          self.new(sunday_before_saturday, last_saturday)
        end


        def all_within(start_date, end_date)
          week_configs = []
          start_at = sunday_before(start_date)
          stop_at = saturday_before(end_date)
          if stop_at < start_at
            start_at -= 7
          end

          begin
            week_configs << self.new(start_at, start_at + 6)
            start_at += 7
          end until (start_at > stop_at)

          week_configs.reverse
        end


        private
        def sunday_before(reference_date)
          reference_date - reference_date.wday
        end

        def saturday_before(reference_date)
          reference_date - (reference_date.wday + 1)
        end
      end
    end
  end
end