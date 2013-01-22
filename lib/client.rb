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

    def query(parameters)
      api = client.discovered_api("analytics", "v3")

      responses = []

      begin
        logger.debug { "Query GA with params: #{parameters}" }

        response = client.execute(api_method: api.data.ga.get, parameters: parameters)

        raise "Response error [#{response.error_message}]" if response.error?

        current_response = JSON.parse(response.body)
        next_start_index = current_response["query"]["start-index"] + current_response["itemsPerPage"]
        parameters = parameters.merge("start-index" => next_start_index)

        responses << current_response
      end while current_response["totalResults"] > next_start_index

      responses
    end

    def client
      @client ||= authenticate(@auth_code)
    end
  end
end
