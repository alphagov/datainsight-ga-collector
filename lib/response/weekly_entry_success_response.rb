require_relative "weekly_response"
require_relative "extract_weekly_dates"

module GoogleAnalytics
  class WeeklyEntrySuccessResponse < BaseResponse
    include ExtractWeeklyDates

    def initialize(response, config_class)
      @site = config_class::SITE_KEY
      @config = config_class
      @messages = create_messages(response)
    end

    private
    ENTRY_LABEL = "Entry"
    SUCCESS_LABEL = "Success"

    def create_messages(response)
      rows = response.reduce([]) { |accumulator, item| accumulator + (item["rows"] || []) }

      collect_by_format(rows).map do |(format, entries, successes)|
        create_message ({
          :start_at => extract_start_at(response.first["query"]["start-date"]),
          :end_at => extract_end_at(response.first["query"]["end-date"]),
          :value => {
            :site => @site,
            :format => normalize_format(format),
            :entries => entries,
            :successes => successes
          }
        })
      end
    end

    def collect_by_format(rows)
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

    def normalize_format(format)
      format.gsub(/^#{@config::CATEGORY_PREFIX}/, '')
    end
  end
end