require "spec_helper"

describe GoogleAnalytics::Collector do

  it "should not allow configs of different types" do
    configs = [
      GoogleAnalytics::Config::WeeklyVisits.new(Date.today - 6, Date.today),
      GoogleAnalytics::Config::WeeklyVisitors.new(Date.today - 6, Date.today)
    ]

    lambda { GoogleAnalytics::Collector.new("any-code", configs) }.should raise_exception
  end

  describe "Collection" do
    module GoogleAnalytics
      class Collector
        public :collect_messages
      end
    end

    class MockResponse
      def initialize data, _
        @data = data
      end

      def messages
        @data[:data].is_a?(Array) ? @data[:data] : [@data[:data]]
      end
    end
    it "should collect messages for one config" do
      config = mock(:config)
      config.should_receive(:response_type).and_return(MockResponse)
      collector = GoogleAnalytics::Collector.new(nil, [config])

      collector.should_receive(:collect).and_return({ :data => :X })

      messages = collector.collect_messages(config)
      messages.should have(1).item
      messages.should include(:X)
    end
  end
end