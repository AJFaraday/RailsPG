class AttributeEffect < SkillEffect

  def use(source,target)
    self.source_character = source
    self.target_character = target
    if evadeable and roll_for_evade
      message = "  #{name} evaded"
      puts message
      message
    elsif defendable and roll_for_defence
      message = "  #{name} defended"
      puts message
      message
    else
      amount = source_character.send(related_trait)
      amount *= magnitude
      critical = roll_for_critical
      if critical
        amount *= CRITICAL_MULTIPLIER
      end
      message =  "  #{"Critical " if critical}#{name}: #{target_trait} #{"+"if amount >= 0}#{amount.to_i}"
      Effect.create!(:character_id => target_character.id,
                     :amount => amount,
                     :source_character_id => source.id,
                     :turns_remaining => length, #TODO modify this by skill level
                     :attribute_effect_id => self.id)
      puts message
      message 
    end
  end


end
