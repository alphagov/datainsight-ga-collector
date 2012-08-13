require 'bundler/setup'
Bundler.require

require_relative '../../lib/date_range'
require_relative '../../lib/visits_response'

require_relative '../../lib/visits_collector'
require_relative '../../lib/config/weekly_visits'
require_relative '../../lib/config/weekly_unique_visitors'

require "json"
