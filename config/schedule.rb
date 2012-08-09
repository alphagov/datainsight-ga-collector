every :sunday, :at => '1am' do
  command "cd #{File.expand_path(File.dirname(__FILE__) + "/../")} && bundle exec bin/collector broadcast"
end
