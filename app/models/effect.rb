class Effect < ActiveRecord::Base

  belongs_to :attribute_effect
  belongs_to :repeat_effect

  belongs_to :character

  validate :has_skill_effect

  # attribute effects just stick around, repeat effects do something every turn
  def turn
    if attribute_effect or repeat_effect
      self.turn_effect if repeat_effect
      self.turns_remaining -= 1
      if self.turns_remaining <= 0
        self.destroy
      else
        self.save
      end
    else 
      puts "Effect doesn't have a related skill effect."  
    end 
  end

  def turn_effect
    #TODO repeat effects
    raise Error
  end


  def has_skill_effect
    unless attribute_effect or repeat_effect
      errors.add(:base, "should be connected to a skill effect.")
    end
  end
  

end
