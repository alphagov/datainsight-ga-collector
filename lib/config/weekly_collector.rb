module GoogleAnalytics
  module Config
    module WeeklyCollector

      def self.included(base)
        base.extend(ClassMethods)
      end

      DIMENSION = "ga:week"
    end

    module ClassMethods
      def last_before(reference_date)
         last_saturday = reference_date - (reference_date.wday + 1)
         sunday_before_saturday = last_saturday - 6
         self.new(sunday_before_saturday, last_saturday)
      end

    end
  end
end