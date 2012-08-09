require 'yaml'
require 'open-uri'
require 'json'

module Collectors
  class VisitsCollector
    include GoogleAuthenticationBridge

    API_SCOPE = "https://www.googleapis.com/auth/analytics.readonly"
    GOOGLE_CLIENT_ID = '1054017153726.apps.googleusercontent.com'
    GOOGLE_CLIENT_SECRET = 'eMFsc8LU3ZGrRFG93WfQCnD3'

    def initialize(auth_code, config)
      @auth_code, @config = auth_code, config
    end

    def collect_as_json
      response.to_pretty_json
    end

    def broadcast
      Bunny.run(ENV['AMQP']) do |client|
        exchange = client.exchange("datainsight", :type => :topic)
        exchange.publish(response.to_json, :key => 'google_analytics.visits.weekly')
      end
    end


    private
    def response
      @response ||= execute(@auth_code)
    end


    def execute(auth_code)
      begin
        client = authenticate(auth_code)
        VisitsResponse.create_from_success(collect(client))
      rescue Exception => e
        VisitsResponse.create_from_error_message(e.message)
      end
    end


    def authenticate(auth_code)
      auth = GoogleAuthentication.new(API_SCOPE, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET)
      auth_token = auth.get_tokens(auth_code)

      client = Google::APIClient.new
      client.authorization.update_token!(auth_token)

      client
    end

    def collect(client)
      analytics_api = client.discovered_api("analytics", "v3")
      parameters = analytics_parameters

      response = client.execute(:api_method => analytics_api.data.ga.get, :parameters => parameters)

      raise "Response error [#{response.error_message}]" if response.error?

      JSON.parse(response.body)
    end

    def analytics_parameters
      last_week = DateRange::get_last_week(Date.today)
      parameters = {}

      parameters["ids"] = @config::GOOGLE_ANALYTICS_URL_ID
      parameters["start-date"] = last_week.first.strftime
      parameters["end-date"] = last_week.last.strftime
      parameters["metrics"] = @config::METRIC
      parameters["dimensions"] = @config::DIMENSION
      parameters["filters"] = @config::FILTER unless @config::FILTER.nil? or @config::FILTER.empty?

      parameters
    end

  end
end

