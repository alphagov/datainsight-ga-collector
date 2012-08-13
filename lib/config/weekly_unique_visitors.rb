module CollectorConfig
  class WeeklyUniqueVisitors
    GOOGLE_ANALYTICS_URL_ID = "ga:53872948"
    METRIC = "ga:visitors"
    DIMENSION = "ga:week"
    UNIT = "visitors"
    AMQP_TOPIC = "google_analytics.unique_visitors.weekly"

    def initialize reference_date
      @reference_date = reference_date
    end

    def analytics_parameters()
      last_week = DateRange::get_last_week(@reference_date)
      parameters = {}

      parameters["ids"] = GOOGLE_ANALYTICS_URL_ID
      parameters["start-date"] = last_week.first.strftime
      parameters["end-date"] = last_week.last.strftime
      parameters["metrics"] = METRIC
      parameters["dimensions"] = DIMENSION

      parameters
    end

    def amqp_topic
      AMQP_TOPIC
    end
  end
end

