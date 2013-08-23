namespace :test do
  desc "Run all RailsPG tests with correct data load"
  task :with_load => ['db:initialize', 'test:without_load']

  desc "Run all RailsPG tests but don't load data."

  Rake::TestTask.new("without_load") do |t|
    t.pattern = '{test/unit/*_test.rb}'
    t.verbose = true
  end
end