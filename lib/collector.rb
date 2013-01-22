require 'yaml'
require 'open-uri'
require 'json'
require 'faraday'
require 'csv'

module Faraday
  module Utils
    DEFAULT_SEP = /[&] */n
  end
end

Datainsight::Logging.configure()

module GoogleAnalytics
  class Collector

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
        nil
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

    def csv
      begin
        messages = @configs.map { |config| collect_messages(config) }.flatten

        headers = [:start_at, :end_at] + messages.first[:payload][:value].keys
        out_file = File.expand_path("../../insidegov.csv", __FILE__)

        CSV.open(out_file, "wb", write_headers: true, headers: headers) do |out|
          messages.each do |m|
            out << [m[:payload][:start_at], m[:payload][:end_at]] + m[:payload][:value].values
          end
        end

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

    def collect(config)
      google_analytics_client = GoogleAnalytics::Client.new(@auth_code)
      results = config.analytics_parameters.map do |parameters|
        google_analytics_client.query(parameters)
      end
      results.flatten
    end

  end
end
