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
    self.source_character = source
    self.target_character = target
    if evadeable and roll_for_evade
      message = "  #{name} evaded\n"
      puts message
      message
    elsif defendable and roll_for_defence
      message = "  #{name} defended\n"
      puts message
      message
    else  
      amount = source_character.send(related_trait)
      amount *= magnitude
      critical = roll_for_critical
      if critical
        amount *= CRITICAL_MULTIPLIER
      end
      message =  "  #{"Critical " if critical}#{name}: #{target_trait} #{"+"if amount >= 0}#{amount.to_i}\n"
      # this gets the result, then adjusts it for max/min on bars
      target_amount = (target_character.send("#{target_trait}") + amount.to_i)
      target_amount = adjust_amount_for_limit(target_amount)
      target_character.update_attribute target_trait, target_amount
      puts message
      message
    end
  end

  def adjust_amount_for_limit(target_amount)
    # only for bars
    if target_character.respond_to?("max_#{target_trait}")
      max = target_character.send("max_#{target_trait}")
      if target_amount > max
        max
      elsif target_amount <= 0
        0
      else
        target_amount
      end
    else
      target_amount
    end
  end

end
