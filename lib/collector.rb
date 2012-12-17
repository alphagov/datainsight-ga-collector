require 'yaml'
require 'open-uri'
require 'json'

Datainsight::Logging.configure()

module GoogleAnalytics
  class Collector
    include GoogleAuthenticationBridge

    GOOGLE_API_SCOPE = "https://www.googleapis.com/auth/analytics.readonly"
    GOOGLE_CREDENTIALS = '/etc/govuk/datainsight/google_credentials.yml'
    GOOGLE_TOKEN = "/var/lib/govuk/datainsight/google-analytics-token.yml"

    def initialize(auth_code, configs)
      @auth_code, @configs = auth_code, configs
    end

    def collect_as_json
      begin
        messages= []
        @configs.each do |config|
          messages += collect_messages(config)
        end
        messages.map(&:to_json)
      rescue => e
        logger.error { e }
      end
    end

    def broadcast
      begin
        logger.info { "Starting to collect google analytics data ..." }
        Bunny.run(ENV['AMQP']) do |client|
          exchange = client.exchange("datainsight", :type => :topic)
          @configs.each do |config|
            messages = collect_messages(config)
            messages.each do |message|
              exchange.publish(message.to_json, :key => config.amqp_topic)
            end
          end
        end
        logger.info { "Collected the google analytics data." }
      rescue => e
        logger.error { e }
      end
    end

    private
    def collect_messages(config)
      collect_response(config).messages
    end

    def collect_response(config)
      begin
        data = collect(config)
        config.response_type.new(data, config.class)
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

    def collect(config)
      analytics_api = client.discovered_api("analytics", "v3")
      parameters = config.analytics_parameters()

      logger.debug { "Query GA with params: #{parameters}" }

      response = client.execute(:api_method => analytics_api.data.ga.get, :parameters => parameters)

      raise "Response error [#{response.error_message}]" if response.error?

      JSON.parse(response.body)
    end

    def client
      @client ||= authenticate(@auth_code)
    end
  end
end

