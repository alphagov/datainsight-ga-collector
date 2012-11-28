module GoogleAnalytics
  class BaseResponse
    attr_reader :messages

    private
    def create_message(payload)
      {
          :envelope => {
              :collected_at => DateTime.now,
              :collector => "Google Analytics",
          },
          :payload => payload
      }
    end
  end
end