# This file contains only system data, which changes how the game works. Not the contents of any specific game.
#
# Seeds should only be for new (for flattened) databases.

require 'csv'

seed_files = Dir["#{Rails.root}/db/seed_tables/*"]
warnings = ""
seed_files.sort!

seed_files.each do |file_name|
  class_name = file_name.split('/')[-1].split('-')[1].split('.')[0].classify
  data_class = class_name.constantize

  puts "Creating: #{class_name}"  

  data = CSV.parse(File.open(file_name).read)
  
  headers = data.shift

  data.each do |row|
    puts row.inspect
    for_after_create = []
    record = data_class.new
    row.each_with_index do |cell,index|
      method_name = headers[index]
      if method_name.include?('=')
        record.send(method_name,cell)
      else
        for_after_create << [method_name,cell]
      end
    end
    record.save!
    for_after_create.each do |method_name,value|
      record.send(method_name,value)
    end
    puts record.inspect
    if record.respond_to?(:check)
      warning = record.check
      warnings << warning if warning
    end 
  end
end

puts warnings
