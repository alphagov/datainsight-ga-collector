require_relative "weekly_response"
require_relative "extract_weekly_dates"

module GoogleAnalytics
  class InsideGovWeeklyPolicyEntriesResponse < BaseResponse
    include ExtractWeeklyDates

    def initialize(response_hash, config_class)
      @site = config_class::SITE_KEY
      @config = config_class
      @messages = create_messages(response_hash)
    end

    private

    def create_messages response_as_hash
      rows = (response_as_hash["rows"] or [])
      condense_to_one_week(rows).map { |slug, entries|
        create_message({
                         start_at: extract_start_at(response_as_hash["query"]["start-date"]),
                         end_at: extract_end_at(response_as_hash["query"]["end-date"]),
                         value: {
                           site: @site,
                           slug: slug,
                           entries: entries
                         }
                       })
      }
    end

    def condense_to_one_week rows
      rows.
        map { |week, slug, entries| [slug, entries.to_i] }.
        group_by { |slug, entries| slug }.
        map { |slug, array|
        [slug, array.map { |slug, entries| entries }.reduce(&:+)]
      }
    end
  end
end