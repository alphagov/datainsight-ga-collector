require_relative "weekly_response"
require_relative "extract_weekly_dates"

module GoogleAnalytics
  class WeeklyContentEngagementDetailResponse < BaseResponse
    include ExtractWeeklyDates

    def initialize(response, config_class)
      @site = config_class::SITE_KEY
      @config = config_class
      @messages = create_messages(response.first)
    end

    private
    ENTRY_LABEL = "Entry"
    SUCCESS_LABEL = "Success"

    def create_messages(response)
      collect_by_slug_and_format(response["rows"]).map do |(slug, format, entries, successes)|
        create_message({
                         start_at: extract_start_at(response["query"]["start-date"]),
                         end_at: extract_end_at(response["query"]["end-date"]),
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