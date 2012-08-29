require 'yaml'
require 'open-uri'
require 'json'

Datainsight::Logging.configure()

module GoogleAnalytics
  class Collector
    include GoogleAuthenticationBridge

    GOOGLE_API_SCOPE = "https://www.googleapis.com/auth/analytics.readonly"
    GOOGLE_CREDENTIALS = '/etc/gds/google_credentials.yml'
    GOOGLE_TOKEN = "/var/lib/gds/google-analytics-token.yml"

    def initialize(auth_code, configs)
      @auth_code, @configs = auth_code, configs
    end

    def collect_as_json
      begin
        collect_messages.map(&:to_json)
      rescue => e
        logger.error { e }
      end
    end

    def broadcast
      begin
        Bunny.run(ENV['AMQP']) do |client|
          collect_messages do |message, config|
            exchange = client.exchange("datainsight", :type => :topic)
            exchange.publish(message.to_json, :key => config.amqp_topic)
          end
        end
      rescue => e
        logger.error { e }
      end
    end

    private
    def collect_messages
      messages = []
      collect_responses do |response, config|
        response.messages.each do |message|
          yield(message, config) if block_given?
          messages << message
        end
      end
      messages
    end

    def collect_responses
      client = authenticate(@auth_code)
      responses = []
      @configs.each do |config|
        response = collect_response(client, config)
        if response
          yield(response, config) if block_given?
          responses << response
        end
      end
      responses
    end

    def collect_response(client, config)
      begin
        config.response_type.new(collect(client, config))
      rescue Exception => e
        logger.error { e }
        nil
      end
    end

    def authenticate(auth_code)
      auth = GoogleAuthentication.create_from_config_file(GOOGLE_API_SCOPE, GOOGLE_CREDENTIALS, GOOGLE_TOKEN)
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

