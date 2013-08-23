namespace :adventure do

  desc "load all adventures from adventure_definitions"
  task :load_all => :environment do
    Dir["adventure_definitions/*-*"].each do |folder|
      Adventure.create_from_folder(folder)
    end
  end

end
