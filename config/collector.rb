require "airbrake"
require_relative "../lib/collector"

Dir[File.expand_path(File.join(File.dirname(__FILE__), "../lib/**/*.rb"))].each { |f| require f }

module DataInsight
  module Collector
    def self.collector(arguments)
      authentication_code = arguments[:authorisation_code]
      GoogleAnalytics::Collector.new(authentication_code, configs(arguments))
    end

    def self.options
      {
        authorisation_code: "Only for the first request you need to pass in the authorisation code",
        config: "The name of the configuration module to specify the what data to collect from GA and where to put it.",
        days_ago: "How many days to go back"
      }
    end

    def self.queue_name(arguments)
      "datainsight"
    end

    def self.queue_routing_key(arguments)
      config_class(arguments)::AMQP_TOPIC
    end

    def self.handle_error(error)
      Airbrake.notify(error)
      true
    end

    private

    def self.config_class(arguments)
      config = arguments[:config]
      unless GoogleAnalytics::Config::Base.descendants.include?(config)
        raise "Invalid collector configuration or none given. Please choose a configuration from [#{GoogleAnalytics::Config::Base.descendants.join(", ")}]."
      end
      GoogleAnalytics::Config.const_get(config)
    end

    def self.configs(arguments)
      config_class = config_class(arguments)
      days_ago = arguments[:days_ago].to_i
      if days_ago.zero?
        if config_class.respond_to?(:for)
          [config_class.for(Date.today - 1)]
        else
          [config_class.last_before(Date.today)]
        end
      else
        config_class.all_within(Date.today - days_ago, Date.today)
      end
    end

  end
end
