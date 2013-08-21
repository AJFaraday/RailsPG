class Door < ActiveRecord::Base

  belongs_to :level
  belongs_to :destination_level, :class_name => 'Level',
             :foreign_key => :destination_level_id

end
