class RepeatEffect < SkillEffect

  def use(source,target)
    messages = []
    self.source_character = source
    self.target_character = target
    if evadeable and roll_for_evade
      messages << "#{name} evaded"
      messages
    elsif defendable and roll_for_defence
      messages << "#{name} defended"
      messages
    else
      amount = source_character.send(related_trait)
      amount *= magnitude
      critical = roll_for_critical
      if critical
        amount *= CRITICAL_MULTIPLIER
      end
      messages << "  #{"Critical " if critical}#{name}: #{target_trait} #{"+"if amount >= 0}#{amount.to_i}\n"
      Effect.create!(:character_id => target_character.id,
                     :amount => amount,
                     :source_character_id => source.id,
                     :turns_remaining => length, #TODO modify this by skill level
                     :repeat_effect_id => self.id)
      messages
    end
  end


end
