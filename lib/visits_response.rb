class VisitsResponse
  SITE_KEY = "govuk"

  attr_reader :message

  def self.create_from_success(response_hash)
    VisitsResponse.new(:success, response_hash)
  end

  def self.create_from_error_message(error_message)
    VisitsResponse.new(:error, {:error => error_message})
  end

  def to_pretty_json
    JSON.pretty_generate(@message)
  end

  def to_json
    @message.to_json
  end

  private
  def initialize(status, response_hash)
    @message = {}
    @message[:envelope] = {
        :collected_at => DateTime.now,
        :collector => "visits",
    }
    if status == :success
      @message[:payload] = parse_success(response_hash)
    elsif status == :error
      @message[:payload] = response_hash
    end
  end

  def parse_success(response)
    {
        :week_starting => response["query"]["start-date"],
        :value => get_total_visits(response["rows"]),
        :site => SITE_KEY
    }
  end


  def get_total_visits(rows)
    rows.inject(0) { |total, row| total + row.last.to_i }
  end
end