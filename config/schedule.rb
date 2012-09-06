def cron_command(config, days_ago = 0)
  root_path = File.expand_path(File.dirname(__FILE__) + "/../")

  "cd #{root_path} && RACK_ENV=production bundle exec bin/collector --config=#{config} --days_ago=#{days_ago} broadcast" +
      " >> #{root_path}/log/cron.out.log 2>> #{root_path}/log/cron.err.log"
end


every :sunday, :at => '5am' do
  command cron_command("WeeklyVisits")
  command cron_command("WeeklyVisitors")
end

# Ten minutes after every full hour
every :hour, :at => '00:10' do
  command cron_command("HourlyVisitors", 1)
end
