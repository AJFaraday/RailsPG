class Level < ActiveRecord::Base

  belongs_to :adventure
  serialize :obstacle_positions

  has_many :characters
  has_many :exits, :class_name => 'Door', :foreign_key => :level_id
  has_many :entrances, :class_name => 'Door', :foreign_key => :destination_level_id

end