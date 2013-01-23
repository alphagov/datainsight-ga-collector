require_relative "weekly_response"
require_relative "extract_weekly_dates"
require_relative "content_engagement_magic"

module GoogleAnalytics
  class WeeklyContentEngagementDetailResponse < BaseResponse
    include ExtractWeeklyDates
    include ContentEngagementMagic

    def initialize(response, config_class)
      @site = config_class::SITE_KEY
      @config = config_class
      @messages = create_all_messages(response)
    end

    private

    def create_all_messages(response)
      start_date = response.first["query"]["start-date"]
      end_date = response.first["query"]["end-date"]
      rows = response.flat_map { |r| r["rows"] || [] }
      create_messages(rows, start_date, end_date)
    end

    def create_messages(rows, start_date, end_date)
      collect_engagement_by_key(
        rows.map { |_, format, slug, action, value|
          [[slug, format], action, value]
        }
      ).map do |(slug, format, entries, successes)|
        create_message({
                           start_at: extract_start_at(start_date),
                           end_at: extract_end_at(end_date),
                           value: {
                               site: @site,
                               format: normalize_format(format, @config::CATEGORY_PREFIX),
                               entries: entries.to_i,
                               successes: successes.to_i,
                               slug: slug
                           }
                       })
      end
    end
  end
end