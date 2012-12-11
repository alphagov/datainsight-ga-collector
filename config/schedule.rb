root_path = File.expand_path(File.dirname(__FILE__) + "/../")
set :output, {
    :standard => "#{root_path}/log/cron.out.log",
    :error => "#{root_path}/log/cron.err.log"
}
job_type :collector, "cd :path && RACK_ENV=:environment bundle exec bin/collector --config=:config --days_ago=:days_ago :task :output"


every :sunday, :at => '5am' do
  collector "broadcast", :config => "WeeklyVisits", :days_ago => 0
  collector "broadcast", :config => "WeeklyVisitors", :days_ago => 0
  collector "broadcast", :config => "WeeklyEntrySuccess", :days_ago => 0

  collector "broadcast", :config => "InsideGovWeeklyVisitors", :days_ago => 0
  collector "broadcast", :config => "InsideGovWeeklyPolicyEntries", :days_ago => 0
  collector "broadcast", :config => "InsideGovWeeklyEntrySuccess", :days_ago => 0
end

# Ten minutes after every full hour
every :hour, :at => '00:10' do
  collector "broadcast", :config => "DailyVisitors", :days_ago => 1
  collector "broadcast", :config => "HourlyVisitors", :days_ago => 1
end
