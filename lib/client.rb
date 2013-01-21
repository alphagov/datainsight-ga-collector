module GoogleAnalytics
  class Client
    include GoogleAuthenticationBridge

    GOOGLE_API_SCOPE = "https://www.googleapis.com/auth/analytics.readonly"
    GOOGLE_CREDENTIALS = '/etc/govuk/datainsight/google_credentials.yml'
    GOOGLE_TOKEN = "/var/lib/govuk/datainsight/google-analytics-token.yml"

    def initialize(auth_code)
      @auth_code = auth_code
    end

    def authenticate(auth_code)
      auth = GoogleAuthentication.create_from_config_file(GOOGLE_API_SCOPE, GOOGLE_CREDENTIALS, GOOGLE_TOKEN)
      auth_token = auth.get_tokens(auth_code)

      client = Google::APIClient.new
      client.authorization.update_token!(auth_token)

      client
    end

    def collect(config)
      results = config.analytics_parameters.map do |parameters|
        query(parameters)
      end

      results
    end

    def query(parameters)
      logger.debug { "Query GA with params: #{parameters}" }

      api = client.discovered_api("analytics", "v3")

      response = client.execute(api_method: api.data.ga.get, parameters: parameters)

      raise "Response error [#{response.error_message}]" if response.error?

      JSON.parse(response.body)
    end

    def client
      @client ||= authenticate(@auth_code)
    end
  end
end
