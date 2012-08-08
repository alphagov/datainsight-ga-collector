# Run:
# ruby visits_collector.rb <AUTHORIZATION_CODE>
#
# To obtain authorization code please visit:
#
# https://accounts.google.com/o/oauth2/auth?response_type=code&scope=https://www.googleapis.com/auth/analytics.readonly&redirect_uri=urn:ietf:wg:oauth:2.0:oob&client_id=1054017153726.apps.googleusercontent.com

require 'yaml'
require 'open-uri'
require 'json'
require_relative 'ga'

class Date
  def self.next_week
    ::Date.today.week_later
  end

  def week_later
    self + 7
  end
end

module Collectors
  class VisitsCollector
    include GoogleAuthenticationBridge

    def initialize(auth_code, config)
      @auth_code, @config = auth_code, config
    end

    def collect_as_response
      JSON.pretty_generate(response)
    end


    private
    def response
      @response ||= execute(@auth_code)
    end


    def execute(auth_code)
      begin
        client = authenticate(auth_code)
        collect(client)
      rescue ::Signet::AuthorizationError => e
        output_with_exception(e.message)
      rescue Exception => e
        output_with_exception(e.message)
      end

    end

    def authenticate(auth_code)
      auth = GoogleAuthentication.new("https://www.googleapis.com/auth/analytics.readonly")
      auth_token = auth.get_tokens(auth_code)

      client = Google::APIClient.new
      client.authorization.update_token!(auth_token)

      client
    end

    def collect(client)
      analytics_api = client.discovered_api("analytics", "v3")
      parameters = analytics_parameters()

      response = client.execute(:api_method => analytics_api.data.ga.get, :parameters => parameters)

      raise "Response error [#{response.error_message}]" if response.error?

      JSON.parse(response.body)
    end

    def analytics_parameters()
      parameters = {}

      parameters["ids"] = @config::GOOGLE_ANALYTICS_URL_ID
      parameters["start-date"] = Date.today.strftime
      parameters["end-date"] = Date.next_week.strftime
      parameters["metrics"] = @config::METRIC
      parameters["dimensions"] = @config::DIMENSION
      parameters["filters"] = @config::FILTER unless @config::FILTER.nil? or @config::FILTER.empty?

      parameters
    end


    def output_with_exception(message)
      puts message
    end

  end
end

