module GoogleAnalytics
  module Config
    module WeeklyCollector
      DIMENSION = "ga:week"

      protected
      def last_saturday
        @reference_date - (@reference_date.wday + 1)
      end

      def sunday_before_saturday
        last_saturday - 6
      end

      alias :end_at :last_saturday
      alias :start_at :sunday_before_saturday
    end
  end
end