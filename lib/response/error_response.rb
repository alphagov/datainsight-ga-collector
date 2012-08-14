require_relative "base_response"

module GoogleAnalytics
  class ErrorResponse < BaseResponse

    def initialize exception
      @messages = []
      @messages << create_message(:error => exception.message)
    end
  end
end