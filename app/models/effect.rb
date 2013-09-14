class Effect < ActiveRecord::Base

  belongs_to :attribute_effect
  belongs_to :repeat_effect

  belongs_to :character
  belongs_to :source_character,
             :foreign_key => :source_character_id,
             :class_name => 'Character'


  validate :has_skill_effect

  delegate :repeat_defendable, :repeat_evadeable, :to => :repeat_effect, :allow_nil => true


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
      ["Effect doesn't have a related skill effect."]
    end
  end

  def turn_effect
    if repeat_defendable and repeat_effect.roll_for_defence
      @message = "  #{sef.name} defended"
    elsif repeat_evadeable and repeat_effect.roll_for_evade
      @message = "  #{self.name} evaded"
    else
      turn_amount = self.amount
      critical = repeat_effect.roll_for_critical
      turn_amount *= SkillEffect::CRITICAL_MULTIPLIER if critical
      character.update_attributes(target_trait =>(character.send(target_trait) + turn_amount),
                                  :last_hit_by_character_id => source_character_id)
      @message = "  #{"Critical " if critical}#{repeat_effect.name}: #{target_trait} #{"+" if turn_amount > 0}#{turn_amount.to_i}\n"
    end
    puts @message
    @message
  end


  def has_skill_effect
    unless attribute_effect or repeat_effect
      errors.add(:base, "should be connected to a skill effect.")
    end
  end

  def target_trait
    if repeat_effect
      repeat_effect.target_trait
    elsif attribute_effect
      attribute_effect.target_trait
    else
      nil
    end
  end

end
