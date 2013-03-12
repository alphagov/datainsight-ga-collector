def underscore(string)
  string.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
end

collector_spec = [
    {:config => 'HourlyVisitors', :days_ago => 30},
    {:config => 'DailyVisitors', :days_ago => 2},
    {:config => 'WeeklyVisits', :days_ago => 200},
    {:config => 'WeeklyVisitors', :days_ago => 200},
    {:config => 'WeeklyContentEngagement', :days_ago => 10},
    {:config => 'WeeklyContentEngagementDetail', :days_ago => 10},
    {:config => 'WeeklyContentEngagementTransaction', :days_ago => 10},
    {:config => 'WeeklyContentEngagementTransactionDetail', :days_ago => 10},
    {:config => 'InsideGovWeeklyVisitors', :days_ago => 200},
    {:config => 'InsideGovWeeklyPolicyEntries', :days_ago => 20},
    {:config => 'InsideGovWeeklyContentEngagement', :days_ago => 20},
    {:config => 'InsideGovWeeklyContentEngagementDetail', :days_ago => 20}
]

namespace :collect do
  initialisation_tasks = Hash[collector_spec.map { |spec| [("init_" + underscore(spec[:config])).to_sym, spec] }]

  desc "Initially collect Google Analytics data and send to queue"
  task :init => initialisation_tasks.keys

  initialisation_tasks.each do |key, params|
    task key, :days_ago, :command do |t, args|
      args.with_defaults(:days_ago => params[:days_ago], :command => "broadcast")
      rack_env = ENV.fetch('RACK_ENV', 'development')
      root_path = File.expand_path(File.dirname(__FILE__) + "/../../")
      sh %{cd #{root_path} && RACK_ENV=#{rack_env} bundle exec collector --config=#{params[:config]} --days_ago=#{args[:days_ago]} #{args[:command]}}
    end
  end

  task :last_week, :command do |t, args|
    args.with_defaults(:command => "broadcast")
    initialisation_tasks.each do |task, _|
      Rake::Task["collect:#{task}"].invoke(7, args[:command])
    end
  end

  namespace :last_week do
    desc "collect data for last week and print"
    task :print do
      Rake::Task["collect:last_week"].invoke("print")
    end

    desc "collect data for last week and send to queue"
    task :broadcast do
      Rake::Task["collect:last_week"].invoke("broadcast")
    end
  end
end
