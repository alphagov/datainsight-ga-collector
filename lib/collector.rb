require 'yaml'
require 'open-uri'
require 'json'

module GoogleAnalytics
  class Collector
    include GoogleAuthenticationBridge

    API_SCOPE = "https://www.googleapis.com/auth/analytics.readonly"
    GOOGLE_CLIENT_ID = '1054017153726.apps.googleusercontent.com'
    GOOGLE_CLIENT_SECRET = 'eMFsc8LU3ZGrRFG93WfQCnD3'

    def initialize(auth_code, configs)
      @auth_code, @configs = auth_code, configs
    end

    def collect_as_json
      collect_messages.map(&:to_json)
    end

    def broadcast
      Bunny.run(ENV['AMQP']) do |client|
        collect_messages do |message, config|
          exchange = client.exchange("datainsight", :type => :topic)
          exchange.publish(message.to_json, :key => config.amqp_topic)
        end
      end
    end


    private
    def collect_messages
      messages = []
      collect_responses do |response, config|
        messages += response.messages.map do |message|
          yield(message, config) if block_given?
          message
        end
      end
      messages
    end


    def collect_responses
      begin
        client = authenticate(@auth_code)
        @configs.map do |config|
          response = collect_response(client, config)
          yield(response, config) if block_given?
          response
        end
      rescue Exception => e
        ErrorResponse.new(e)
      end
    end

    def collect_response(client, config)
      begin
        config.response_type.new(collect(client, config))
      rescue Exception => e
        ErrorResponse.new(e)
      end
    end


    def authenticate(auth_code)
      auth = GoogleAuthentication.new(API_SCOPE, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET)
      auth_token = auth.get_tokens(auth_code)

      client = Google::APIClient.new
      client.authorization.update_token!(auth_token)

      client
    end

    def collect(client, config)
      analytics_api = client.discovered_api("analytics", "v3")
      parameters = config.analytics_parameters()

      response = client.execute(:api_method => analytics_api.data.ga.get, :parameters => parameters)

      raise "Response error [#{response.error_message}]" if response.error?

      JSON.parse(response.body)
    end

  end
end

