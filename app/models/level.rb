class Level < ActiveRecord::Base

  belongs_to :adventure
  serialize :obstacle_positions

  has_many :characters, :dependent => :destroy do
     
    def at(game_id, row, column)
      find_all_by_game_id_and_row_and_column(game_id,row,column)   
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

  attr_accessor :grid

  delegate :line_of_sight_between, :out_of_range?, :in_range?, :distance_from,  :to => :grid

  after_initialize :init_grid

  # character positions in the current game
  attr_accessor :character_positions

  def init_grid
    self.grid = Grid.new(:rows => rows,
                           :columns => columns,
                           :obstacles => obstacle_positions)
  end

  def path_from(a,b)
    if self.character_positions
      self.grid.obstacles = self.grid.obstacles.concat(self.character_positions)
    end
    self.grid.path_from(a,b)
  end

  def players
    characters.where(:player => true)
  end

  def enemies
    characters.where(:player => false)
  end

end
