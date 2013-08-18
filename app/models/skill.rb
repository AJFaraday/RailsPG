class Skill < ActiveRecord::Base

  has_many :character_class_skills
  has_many :character_classes, :through => :character_class_skills

  has_many :skill_effects

  def check
    puts "Checking Skill: #{self.name}(#{self.label})"
    puts "  Skill is for character classes: #{character_classes.collect{|x|x.name}.join(', ')}"
    puts "  Skill has these effects: #{skill_effects.collect{|x|x.name}.join(', ')}"
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
    message = "#{source_character.name} uses #{label} on #{target_character.name}\n"
    puts message
    skill_effects.each{|effect|message << effect.use(source_character,target_character)}
    message
  end

end
