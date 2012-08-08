# Run:
# ruby visits_collector.rb <AUTHORIZATION_CODE>
#
# To obtain authorization code please visit:
#
# https://accounts.google.com/o/oauth2/auth?response_type=code&scope=https://www.googleapis.com/auth/analytics.readonly&redirect_uri=urn:ietf:wg:oauth:2.0:oob&client_id=1054017153726.apps.googleusercontent.com

require 'bundler/setup'
Bundler.require

require 'yaml'
require 'open-uri'
require 'json'
require_relative 'ga'

module Collectors
  class VisitsCollector

    def initialize(config)
      @config = config
    end

    def print
      puts @response.to_json
    end


    def run(authorization_code)
      @client = Google::APIClient.new
      google_authentication = GoogleAuthenticationBridge::GoogleAuthentication.new("https://www.googleapis.com/auth/analytics.readonly")
      @client.authorization.update_token!(
          google_authentication.get_tokens(authorization_code))


      begin
        @gov_uk_analytics = @client.discovered_api("analytics", "v3")
        @response = collect_data()
      rescue ::Signet::AuthorizationError => e
        output_with_exception(e.message)
      rescue Exception => e
        output_with_exception(e.message)
      end

    end

    def collect_data()
      date_week_after = Date.today + 14
      input = {"ids" => @config::GOOGLE_ANALYTICS_URL_ID,
               "start-date" => Date.today.strftime,
               "end-date" => date_week_after.strftime,
               "metrics" => @config::METRIC,
               "dimensions" => @config::DIMENSION}
      if not @config::FILTER.nil? and not @config::FILTER.empty?
        input["filters"] = @config::FILTER
      end
      response = @client.execute(@gov_uk_analytics.data.ga.get, input)
      response = JSON.parse(response.body)
      if response["error"]
        raise "Response error [#{response["error"]["message"]}"
      end
      response
    end


    def output_with_exception(message)
      puts message
    end

  end
end

