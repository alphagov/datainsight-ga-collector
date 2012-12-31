require 'bundler/setup'
Bundler.require

Dir[File.expand_path(File.join(File.dirname(__FILE__), "../../lib/**/*.rb"))].each {|f| require f}

require "json"

def load_json(filename)
  JSON.parse(File.read(File.join(File.dirname(__FILE__), "../data", filename)))
end

class DummyConfig
  METRIC = "ga:dummy"
  SITE_KEY = "govuk"
end