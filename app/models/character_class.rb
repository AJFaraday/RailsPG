class CharacterClass < ActiveRecord::Base

  validates_uniqueness_of :name
  
  has_many :character_class_skills
  has_many :skills, :through => :character_class_skills
 
  # Check for incorrect/unbalanced characters
  #
  # There to test my reasoning in creating seeds
  def check
    # debug info
    puts "Checking CharacterClass: #{self.name}" 
    puts "  Initial bars sum up to: #{self.initial_bars.values.sum}"
    puts "  Initial traits sum up to: #{self.initial_traits.values.sum}"
    puts "  Bar modifiers sum up to: #{self.bar_modifiers.values.sum}"
    puts "  Trait modifiers sum up to: #{self.trait_modifiers.values.sum}"
    # collecting warnings
    if self.playable
      problems = false
      warnings = ""
      unless self.initial_bars.values.sum == 40
        problems = true
        warnings << "  Initial bars (health and skill) should add up to 40\n"
      end
      unless self.initial_traits.values.sum == 20
        problems = true
        warnings << "  Initial Traits should add up to 20\n"
      end
      unless self.bar_modifiers.values.sum == 30
        problems = true
        warnings << "  Modifiers for bars (health and skill) should add up to 30\n"
      end
      unless self.trait_modifiers.values.sum == 20
        problems = true
        warnings << "  Modifiers for Traits should add up to 20\n"
      end
      if self.trait_modifiers.any?{|key,value|value > 5}
        problems = true
        warnings << "  Modifiers over 5 will exceed 100 on the level cap."
      end
      if problems
        message = "Problems with CharacterClass: #{name}\n#{warnings}"
        puts message
        return message
      else 
        nil
      end
    end
  end
 

  # This is how much of each attribute a character will start with
  def initial_attributes
    Hash[self.attributes.select{|a,b|a.include?('init_')}]    
  end

  # initial attributes, not health and skill
  def initial_traits
    traits = self.initial_attributes
    traits.delete('init_health')
    traits.delete('init_skill')
    traits
  end 

  # initial health and skill points
  def initial_bars
    {:init_health => init_health,
     :init_skill => init_skill}
  end 

  # This is how much each attribute should increase by at each level
  def attribute_modifiers
    Hash[self.attributes.select{|a,b|a.include?('_mod')}]
  end

  # initial attributes, not health and skill
  def trait_modifiers
    traits = self.attribute_modifiers
    traits.delete('health_mod')
    traits.delete('skill_mod')
    traits
  end 

  def bar_modifiers
    {:health_mod => health_mod,
     :skill_mod => skill_mod}
  end 

 
end
