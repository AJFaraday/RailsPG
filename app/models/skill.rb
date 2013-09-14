class Skill < ActiveRecord::Base

  has_many :character_class_skills
  has_many :character_classes, :through => :character_class_skills

  has_many :skill_effects

  has_many :character_skills
  has_many :characters, :through => :character_skills

  def check
    puts "Checking Skill: #{self.name}(#{self.label})"
    puts "  Skill is for character classes: #{character_classes.collect{|x|x.name}.join(', ')}"
    puts "  Skill has these effects: #{skill_effects.collect{|x|x.name}.join(', ')}"
  end

  def to_s
    "Skill #{self.id}: #{self.label}(#{self.name})"
  end

  def menu_label
    "#{label} (#{skill_cost} skill)"
  end

  def tooltip
    <<TEXT 
      Cost: #{skill_cost}
      Range: #{range}
TEXT
  end

  def add_to_classes(classes)
    # used in import
    classes = eval("[#{classes}]") if classes.is_a?(String)
    classes.each do |kls|
      character_class = CharacterClass.find_by_name(kls[0])
      character_class_skills.create(:character_class_id => character_class.id,
                                    :from_level => kls[1],
                                    :automatic => kls[2])
    end
  end

  def use(source_character,target_character)
    source_character = Character.find(source_character) unless source_character.is_a?(Character)
    target_character = Character.find(target_character) unless target_character.is_a?(Character)
    if source_character.skill < self.skill_cost
      message = "#{source_character.name} can't use #{label}, not enough skill."
      puts message
      message
    else
      source_character.update_attribute(:skill, (source_character.skill - self.skill_cost))
      messages = ["#{source_character.name} uses #{label} on #{target_character.name}"]
      skill_effects.each{|effect|messages << effect.use(source_character,target_character)}
      messages
    end
  end

end
