require_relative "weekly_response"
require_relative "extract_weekly_dates"

module GoogleAnalytics
  class InsideGovWeeklyPolicyEntriesResponse < BaseResponse
    include ExtractWeeklyDates

    def initialize(response, config_class)
      @site = config_class::SITE_KEY
      @config = config_class
      @messages = create_messages(response.first)
    end

    private

    def create_messages response_as_hash
      rows = (response_as_hash["rows"] or [])
      collect_by_slug(rows).map { |slug, entries|
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

    def collect_by_slug rows
      entries_by_slug = discard_week(rows).group_by { |slug, _| slug }
      sum_entries(entries_by_slug)
    end

    def sum_entries(entries_by_slug)
      entries_by_slug.map { |slug, array| [slug, array.map { |_, entries| entries }.reduce(&:+)] }
    end

    def discard_week(rows)
      rows.map { |slug, entries| [slug, entries.to_i] }
    end
  end
end