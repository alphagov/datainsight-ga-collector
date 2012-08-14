every :sunday, :at => '1am' do
  command "cd #{File.expand_path(File.dirname(__FILE__) + "/../")} && bundle exec bin/collector --config=WeeklyVisits broadcast"
end

every :sunday, :at => '1am' do
  command "cd #{File.expand_path(File.dirname(__FILE__) + "/../")} && bundle exec bin/collector --config=WeeklyVisitors broadcast"
end

# Ten minutes after every full hour
every :hour, :at => '00:10' do
  command "cd #{File.expand_path(File.dirname(__FILE__) + "/../")} && bundle exec bin/collector --config=HourlyVisitors broadcast"
end
