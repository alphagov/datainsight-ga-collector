module CollectorConfig
  class WeeklyVisits
    GOOGLE_ANALYTICS_URL_ID = "ga:53872948"
    METRIC = "ga:visits"
    DIMENSION = "ga:week"

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
  end
end
