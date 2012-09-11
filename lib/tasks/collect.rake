namespace :collect do
  desc "Initially collect Google Analytics data"
  task :init => [:init_hourly_vistors, :init_weekly_visits, :init_weekly_visitors]

  {
      :init_hourly_vistors => {:config => 'HourlyVisitors', :days_ago => 30},
      :init_weekly_visits => {:config => 'WeeklyVisits', :days_ago => 200},
      :init_weekly_visitors => {:config => 'WeeklyVisitors', :days_ago => 200}
  }.each do |key, params|
    task key do
      rack_env = ENV.fetch('RACK_ENV', 'development')
      root_path = File.expand_path(File.dirname(__FILE__) + "/../../")
      sh %{cd #{root_path} && RACK_ENV=#{rack_env} bundle exec bin/collector --config=#{params[:config]} --days_ago=#{params[:days_ago]} broadcast}
    end
  end
end