require 'bundler/setup'
Bundler.require

require_relative '../../lib/collector'

require_relative '../../lib/collectors/weekly_visits'
require_relative '../../lib/collectors/weekly_visitors'
require_relative '../../lib/collectors/hourly_visitors'
require_relative '../../lib/collectors/weekly_entry_success'
require_relative '../../lib/collectors/daily_visitors'
require_relative '../../lib/collectors/inside_gov_weekly_visitors'

require "json"

def load_json(filename)
  JSON.parse(File.read(File.join(File.dirname(__FILE__), "../data", filename)))
end

class DummyConfig
  METRIC = "ga:dummy"
  SITE_KEY = "govuk"
end