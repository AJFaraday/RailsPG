namespace :db do

  desc "Wipes database and rebuilds it from seeds"
  task :initialize => ['db:drop','db:create','db:migrate','db:seed']

end

