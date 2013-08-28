class Level < ActiveRecord::Base

  belongs_to :adventure
  serialize :obstacle_positions

  has_many :characters, :dependent => :destroy do
     
    def at(game_id, row, column)
      find_by_game_id_and_row_and_column(game_id,row,column)   
    end

    def adventure
      find_by_adventure_id(self.adventure_id)
    end

  end

  has_many :doors, :dependent => :destroy do
    def at(row,column)
      find_by_row_and_column(row, column)
    end
  end 
  has_many :exits, :class_name => 'Door', :foreign_key => :level_id
  has_many :entrances, :class_name => 'Door', :foreign_key => :destination_level_id

  def players
    characters.all(:conditions => ['player = ?',true])
  end

  def enemies
    characters.all(:conditions => ['player = ?',false])
  end

end
