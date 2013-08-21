class Level < ActiveRecord::Base

  belongs_to :adventure
  serialize :obstacle_positions

  has_many :characters, :dependent => :destroy

  has_many :doors, :dependent => :destroy
  has_many :exits, :class_name => 'Door', :foreign_key => :level_id
  has_many :entrances, :class_name => 'Door', :foreign_key => :destination_level_id


  def players
    characters.all(:conditions => ['player = ?',true])
  end

  def enemies
    characters.all(:conditions => ['player = ?',false])
  end

end