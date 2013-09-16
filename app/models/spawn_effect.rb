class SpawnEffect < SkillEffect

  belongs_to :spawn_character_class,:foreign_key => :spawn_character_class_id, :class_name => 'CharacterClass'


  def use(source,target)
    messages = []
    self.source_character = source
    self.target_character = target
    level = magnitude
    # TODO modify this by effect level with magnitude mod
    messages << "#{name} spawned. Level: #{level.to_i}"
    Character.create!(:player => source_character.player,
                      :character_class_id => spawn_character_class.id,
                      :game_id => source.game_id,
                      :level_id => source.level_id,
                      :row => source.row,
                      :column => source.column,
                      :name => name,
                      :level => level)
    messages 
  end

  def set_spawn_class(name)
    character_class = CharacterClass.find_by_name(name)
    raise "No character class called #{name} (from spawn_effect#set_spawn_class)" unless character_class
    self.spawn_character_class_id = character_class.id
  end

end
