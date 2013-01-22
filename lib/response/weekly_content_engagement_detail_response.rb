require_relative "weekly_response"
require_relative "extract_weekly_dates"

module GoogleAnalytics
  class WeeklyContentEngagementDetailResponse < BaseResponse
    include ExtractWeeklyDates

    def initialize(response, config_class)
      @site = config_class::SITE_KEY
      @config = config_class
      @messages = create_all_messages(response)
    end

    private
    ENTRY_LABEL = "Entry"
    SUCCESS_LABEL = "Success"

    def create_all_messages(response)
      start_date = response.first["query"]["start-date"]
      end_date = response.first["query"]["end-date"]
      rows = response.flat_map { |r| r["rows"] }
      create_messages(rows, start_date, end_date)
    end

    def create_messages(rows, start_date, end_date)
      collect_by_slug_and_format(rows).map do |(slug, format, entries, successes)|
        create_message({
                           start_at: extract_start_at(start_date),
                           end_at: extract_end_at(end_date),
                           value: {
                               site: @site,
                               format: format,
                               entries: entries.to_i,
                               successes: successes.to_i,
                               slug: slug
                           }
                       })
      end
    end

    # returns [ [slug, format, entries, successes], ... ]
    def collect_by_slug_and_format(rows)
      weeks = {}
      rows.each do |(_, format, slug, action, value)|
        weeks[[slug, format]] ||= [0, 0]
        if action == ENTRY_LABEL
          weeks[[slug, format]][0] += value.to_i
        elsif action == SUCCESS_LABEL
          weeks[[slug, format]][1] += value.to_i
        else
          logger.warn { "Unrecognized action '#{action}' for format '#{format}'" }
        end
      end
      weeks.map(&:flatten)
    end
  end
end