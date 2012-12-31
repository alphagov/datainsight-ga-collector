require_relative '../spec_helper'

describe "Google Analytics Collector" do

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


  describe "Collection" do

    it "should collect messages for one config" do
      config = mock(:config)
      config.should_receive(:response_type).and_return(MockResponse)
      collector = GoogleAnalytics::Collector.new(nil, [config])

      collector.should_receive(:collect).and_return({:data => :X})

      messages = collector.collect_messages(config)
      messages.should have(1).item
      messages.should include(:X)
    end
  end

  describe "Broadcast" do

    before(:each) do
      @config = mock(:config)
      @config.stub(:response_type).and_return(MockResponse)
      @config.stub(:amqp_topic).and_return('__test.topic__')
    end

    def mock_exchange
      client = mock(:amqp_client)
      exchange = mock(:amqp_exchange)
      client.should_receive(:exchange).with('datainsight', :type => :topic).and_return(exchange)
      Bunny.should_receive(:run).and_yield(client)

      exchange
    end

    it "should subscribe to AMQP" do
      client = mock(:amqp_client)
      exchange = mock(:amqp_exchange)
      exchange.stub(:publish)
      client.should_receive(:exchange).with('datainsight', :type => :topic).and_return(exchange)
      Bunny.should_receive(:run).with(ENV['AMQP']).and_yield(client)

      collector = GoogleAnalytics::Collector.new(nil, [@config])
      collector.stub(:collect).and_return({:data => :X})

      collector.broadcast
    end

    it "should publish one message from one config" do
      exchange = mock_exchange
      exchange.should_receive(:publish).with('"X"', {:key => '__test.topic__'})

      collector = GoogleAnalytics::Collector.new(nil, [@config])
      collector.stub(:collect).and_return({:data => :X})

      collector.broadcast
    end

    it "should publish more message from one config" do
      exchange = mock_exchange
      exchange.should_receive(:publish).with('"X"', {:key => '__test.topic__'})
      exchange.should_receive(:publish).with('"Y"', {:key => '__test.topic__'})
      exchange.should_receive(:publish).with('"Z"', {:key => '__test.topic__'})
      exchange.should_receive(:publish).with('"A"', {:key => '__test.topic__'})

      collector = GoogleAnalytics::Collector.new(nil, [@config])
      collector.stub(:collect).and_return({:data => [:X, :Y, :Z, :A]})

      collector.broadcast
    end

    it "should publish more messages for more configs" do
      exchange = mock_exchange
      exchange.should_receive(:publish).with('"X"', {:key => '__test.topic__'})
      exchange.should_receive(:publish).with('"Y"', {:key => '__test.topic__'})
      exchange.should_receive(:publish).with('"Z"', {:key => '__test.topic__'})
      exchange.should_receive(:publish).with('"A"', {:key => '__test.topic__'})
      exchange.should_receive(:publish).with('"A"', {:key => '__test.topic__'})

      collector = GoogleAnalytics::Collector.new(nil, [@config, @config])
      collector.stub(:collect).exactly(2).times.and_return({:data => [:X, :Y, :Z]}, {:data => [:A]*2})

      collector.broadcast
    end
  end
end