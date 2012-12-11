require_relative "weekly_response"
require_relative "extract_weekly_dates"

module GoogleAnalytics
  class WeeklyEntrySuccessResponse < BaseResponse
    include ExtractWeeklyDates

    def initialize(response_hash, config_class)
      @site = config_class::SITE_KEY
      @config = config_class
      @messages = create_messages(response_hash)
    end

    private
    ENTRY_LABEL = "Entry"
    SUCCESS_LABEL = "Success"

    def create_messages response_as_hash
      rows = (response_as_hash["rows"] or [])
      condense_to_one_week(rows).map do |(format, entries, successes)|
        create_message ({
            :start_at => extract_start_at(response_as_hash["query"]["start-date"]),
            :end_at => extract_end_at(response_as_hash["query"]["end-date"]),
            :value => {
              :site => @site,
              :format => normalize_format(format),
              :entries => entries,
              :successes => successes
            }
        })
      end
    end

    def condense_to_one_week rows
      weeks = {}
      rows.each do |(_, format, action, value)|
        weeks[format] ||= [0, 0]
        if action == ENTRY_LABEL
          weeks[format][0] += value.to_i
        elsif action == SUCCESS_LABEL
          weeks[format][1] += value.to_i
        else
          logger.warn { "Unrecognized action '#{action}' for format '#{format}'" }
        end
      end
      weeks.map(&:flatten)
    end

    def normalize_format format
      format.gsub(/^#{@config::CATEGORY_PREFIX}/, '')
    end
  end
end