require_relative "weekly_response"

module GoogleAnalytics
  class WeeklyEventResponse < WeeklyResponse

    protected
    FORMAT_KEY = 1
    ACTION_KEY = 2
    VALUE_KEY = 3

    def create_messages response_as_hash
      condense_to_one_week(response_as_hash["rows"]).map do |row|
        create_message ({
            :start_at => extract_start_at(response_as_hash["query"]["start-date"]),
            :end_at => extract_end_at(response_as_hash["query"]["end-date"]),
            :value => row[VALUE_KEY].to_i,
            :site => SITE_KEY,
            :format => row[FORMAT_KEY],
            :action => row[ACTION_KEY]
        })
      end
    end

    def condense_to_one_week rows
      weeks = {}
      rows.each { |row| row[VALUE_KEY] = row[VALUE_KEY].to_i }.each do |row|
        key = [row[FORMAT_KEY],row[ACTION_KEY]]
        if weeks[key]
          weeks[key][VALUE_KEY] += row[VALUE_KEY]
        else
          weeks[key] = row
        end
      end
      weeks.values
    end
  end
end