require 'bundler/setup'
Bundler.require

require_relative '../../lib/collector'

require_relative '../../lib/config/weekly_visits'
require_relative '../../lib/config/weekly_visitors'
require_relative '../../lib/config/hourly_visitors'
require_relative '../../lib/config/weekly_entry_success'
require_relative '../../lib/config/daily_visitors'

require "json"

def load_json(filename)
  JSON.parse(File.read(File.join(File.dirname(__FILE__), "../data", filename)))
end