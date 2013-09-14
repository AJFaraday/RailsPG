class SkillEffect < ActiveRecord::Base

  belongs_to :skill
  
  delegate :name, :to => :skill, :prefix => :skill, :allow_nil => true

  CRITICAL_MULTIPLIER = 1.5

  def check
    puts "Checking SkillEffect: #{name}:"
    puts "  effect is on skill: #{skill_name}"
  end

  def set_skill(name)
    puts "setting skill for effect"
    # this should only be called on setup! once !
    raise Error if self.skill
    s = Skill.find_by_name(name)
    raise "No skill by with name #{name} found!" unless 
    self.skill = s
  end

  # for use in-game

  attr_accessor :target_character
  attr_accessor :source_character

  def roll(percent)
    rand(100) <= percent
  end

  def roll_for_evade()
    roll(target_character.evade)
  end

  def roll_for_defence()
    roll(target_character.defence)
  end

  def roll_for_critical()
    roll(source_character.send(related_trait))
  end

  def use(source,target)
    puts "Using SkillEffect use method, which does nothing. Should come from a sub-class"
  end

end
