class Game < ActiveRecord::Base

  belongs_to :adventure
  
  has_many :levels, :through => :adventure
 
  has_many :characters 

  belongs_to :current_character, :class_name => 'Character', 
             :foreign_key => :current_character_id

  has_one :current_level, 
          :through => :current_character, 
          :class_name => 'Level', :source => :level
  
  serialize :player_order


  def Game.start_adventure(adventure,ip="localhost")
    adventure = Adventure.find(adventure) if adventure.is_a?(Integer) 
    raise "You need an adventure to start an adventure!" unless adventure.is_a?(Adventure)
    Game.find_all_by_ip_address(ip).each{|x|x.update_attribute(:current, false)}
    game = Game.create!(:adventure_id => adventure.id,
                        :name => adventure.name,
                        :ip_address => ip,
                        :current => true)
    game.clone_adventure_characters
    game.set_player_order
    return game
  end

  def set_player_order
    character_ids = self.players.order('speed desc').collect{|x|x.id}
    self.update_attributes(
      :player_order => character_ids,
      :current_character_id => character_ids[0]
    )
  end

  def clone_adventure_characters
    characters.destroy_all
    adventure.characters.each do |character|
      new_character = character.dup
      new_character.adventure_id = nil
      new_character.game_id = self.id
      new_character.save!
      character.character_skills.each do |skill|
        new_character.character_skills.create(:skill_id => skill.skill_id, 
                                              :level => skill.level)
      end
    end
  end

  def players
    characters.where(:player => true)
  end

  def enemies
    characters.where(:player => false)
  end

  def finish_turn
    messages = []
    messages << current_character.finish_turn
    current_character.current_level.enemies.where(:game_id => self.id).each do |enemy|
      messages << enemy.automatic_turn
    end
    update_attributes(:current_character_id => (player_order[(player_order.index(current_character_id) + 1)] || player_order[0]))
    messages << "It's #{current_character.name}'s turn."
    messages
  end
  

end
