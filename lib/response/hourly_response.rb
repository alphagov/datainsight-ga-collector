require_relative 'base_response'
module GoogleAnalytics
  class HourlyResponse < BaseResponse

    def initialize(response, config_class)
      @site = config_class::SITE_KEY
      @metric = config_class::METRIC.split(":")[1].to_sym
      @messages = create_messages(response.first)
    end

    private
    def create_messages(response)
      start_date = Date.parse(response["query"]["start-date"])
      end_date = Date.parse(response["query"]["end-date"])
      rows = (response["rows"] or [])
      rows.map do |row|
        create_message(create_payload(start_date, end_date, row))
      end
    end

    def create_payload(start_date, end_date, row)
      hour = row.first.to_i
      value = row.last.to_i

      {
          :start_at => format_datetime(start_date, hour),
          :end_at => format_datetime(start_date, hour+1),
          :value => {
            @metric => value,
            :site => @site
          }
      }
    end

    def format_datetime(date, hour)
      DateTime.new(date.year, date.month, date.day, hour).strftime
    end

  end
end