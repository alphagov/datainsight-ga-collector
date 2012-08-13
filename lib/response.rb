module GoogleAnalytics
  class Response
    SITE_KEY = "govuk"

    attr_reader :message

    def self.create_from_success(response_hash)
      Response.new(:success, response_hash)
    end

    def self.create_from_error_message(error_message)
      Response.new(:error, {:error => error_message})
    end

    def to_json
      @message.to_json
    end

    private
    def initialize(status, response_hash)
      @message = {}
      @message[:envelope] = {
          :collected_at => DateTime.now,
          :collector => "Google Analytics",
      }
      if status == :success
        @message[:payload] = parse_success(response_hash)
      elsif status == :error
        @message[:payload] = response_hash
      end
    end

    def parse_success(response)
      {
          :start_at => extract_start_at(response["query"]["start-date"]),
          :end_at => extract_end_at(response["query"]["end-date"]),
          :value => get_total_visits(response["rows"]),
          :site => SITE_KEY
      }
    end

    def extract_start_at(start_date)
      DateTime.parse(start_date).strftime
    end

    def extract_end_at(end_date)
      (DateTime.parse(end_date)+1).strftime
    end


    def get_total_visits(rows)
      rows.inject(0) { |total, row| total + row.last.to_i }
    end
  end
end