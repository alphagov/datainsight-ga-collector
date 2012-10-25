require_relative 'base_response'
module GoogleAnalytics
  class DailyResponse < BaseResponse

    def initialize(response, config)
      @metric = config::METRIC.split(":")[1].to_sym
      @messages = [create_message(create_payload(response))]
    end

    private
    def create_payload(response)
      value = response['totalsForAllResults']['ga:visitors'].to_i

      start_at = Date.parse(response["query"]["start-date"]).to_datetime
      end_at = (start_at+1)

      {
          :start_at => start_at.strftime,
          :end_at => end_at.strftime,
          :value => {
              @metric => value,
              :site => SITE_KEY
          }
      }
    end
  end
end