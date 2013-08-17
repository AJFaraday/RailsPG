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

  def roll(percent)
    rand(100) <= percent
  end

  def use(source_character,target_character)
    if evadeable and roll(target_character.evade)
      puts "  #{name} evaded"
    elsif defendable and roll(target_character.defence)
      puts "  #{name} blocked"
    else  
      amount = source_character.send(related_trait)
      amount *= magnitude
      amount = (amount * (rand(100.0)/100.0)).to_i + 1 #plus one to ensure some effect
      target_character.update_attribute target_trait, (target_character.send("#{target_trait}") + amount)
      puts "  #{name}: #{target_trait} #{amount}"
    end
  end

end
