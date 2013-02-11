def underscore(string)
  string.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
end

collector_spec = [
    {:config => 'HourlyVisitors', :days_ago => 30},
    {:config => 'DailyVisitors', :days_ago => 2},
    {:config => 'WeeklyVisits', :days_ago => 200},
    {:config => 'WeeklyVisitors', :days_ago => 200},
    {:config => 'WeeklyContentEngagement', :days_ago => 100},
    {:config => 'WeeklyContentEngagementDetail', :days_ago => 100},
    {:config => 'WeeklyContentEngagementTransaction', :days_ago => 100},
    {:config => 'WeeklyContentEngagementTransactionDetail', :days_ago => 100},
    {:config => 'InsideGovWeeklyVisitors', :days_ago => 200},
    {:config => 'InsideGovWeeklyPolicyEntries', :days_ago => 200},
    {:config => 'InsideGovWeeklyContentEngagement', :days_ago => 200},
    {:config => 'InsideGovWeeklyContentEngagementDetail', :days_ago => 200}
]

namespace :collect do
  desc "Initially collect Google Analytics data"
  initialisation_tasks = Hash[collector_spec.map { |spec| [("init_" + underscore(spec[:config])).to_sym, spec] }]
  task :init => initialisation_tasks.keys
  initialisation_tasks.each do |key, params|
    task key do
      rack_env = ENV.fetch('RACK_ENV', 'development')
      root_path = File.expand_path(File.dirname(__FILE__) + "/../../")
      sh %{cd #{root_path} && RACK_ENV=#{rack_env} bundle exec collector --config=#{params[:config]} --days_ago=#{params[:days_ago]} broadcast}
    end
  end
end