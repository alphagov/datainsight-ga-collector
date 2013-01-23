require 'yaml'
require 'open-uri'
require 'json'
require 'faraday'

module Faraday
  module Utils
    DEFAULT_SEP = /[&] */n
  end
end

Datainsight::Logging.configure()

module GoogleAnalytics
  class Collector

    def initialize(auth_code, configs)
      if configs.group_by { |config| config.class }.keys.count != 1
        raise "All configs should be of the same class"
      end
      @auth_code, @configs = auth_code, configs
    end

    def messages
      @configs.flat_map { |config| collect_messages(config) }
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
