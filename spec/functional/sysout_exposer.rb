#!/usr/bin/env ruby
require "bundler/setup"
Bundler.require

class SystemOutExposer

  def initialize()
    client = Bunny.new ENV['AMQP']
    client.start
    @queue = client.queue(ENV['QUEUE'] || '_weekly_visits_')
    exchange = client.exchange('datainsight', :type => :topic)

    @queue.bind(exchange, :key => 'google_analytics.visits.weekly')
    puts "Bound to google_analytics.visits.weekly, listening for events"
  end

  def run
    @queue.subscribe do |msg|
      puts "Received a message:"
      p msg
    end
  end
end

SystemOutExposer.new.run