class SkillEffect < ActiveRecord::Base

  belongs_to :skill
  
  delegate :name, :to => :skill, :prefix => :skill, :allow_nil => true

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

end
