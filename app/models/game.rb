class Game < ActiveRecord::Base

  belongs_to :adventure
  
  has_many :levels, :through => :adventure
 
  has_many :characters
  
  def Game.start_adventure(adventure,ip="localhost")
    adventure = Adventure.find(adventure) if adventure.is_a?(Integer) 
    raise "You need an adventure to start an adventure!" unless adventure.is_a?(Adventure)
    Game.find_all_by_ip_address(ip).each{|x|x.update_attribute(:current, false)}
    game = Game.create!(:adventure_id => adventure.id,
                        :name => adventure.name,
                        :ip_address => ip,
                        :current => true)
    game.clone_adventure_characters
    return game
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

end
