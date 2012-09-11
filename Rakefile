require 'rubygems'
require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'
Dir.glob('lib/tasks/*.rake').each { |r| import r }

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
end
