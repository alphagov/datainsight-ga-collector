require 'bundler/setup'
Bundler.require

require_relative '../../lib/response/error_response'
require_relative '../../lib/collector'

require_relative '../../lib/config/weekly_visits'
require_relative '../../lib/config/weekly_unique_visitors'
require_relative '../../lib/config/hourly_unique_visitors'

require "json"
