require_relative 'base_response'
module GoogleAnalytics
  class HourlyResponse < BaseResponse

    def initialize(response)
      @messages = create_messages(response)
    end

    private
    def create_messages(response)
      start_date = Date.parse(response["query"]["start-date"])
      end_date = Date.parse(response["query"]["end-date"])
      response["rows"].map do |row|
        create_message(create_payload(start_date, end_date, row))
      end
    end

    def create_payload(start_date, end_date, row)
      hour = row.first.to_i
      value = row.last.to_i

      {
          :start_at => format_datetime(start_date, hour),
          :end_at => format_datetime(start_date, hour+1),
          :value => value,
          :site => SITE_KEY
      }
    end

    def format_datetime(date, hour)
      DateTime.new(date.year, date.month, date.day, hour).strftime
    end

  end
end