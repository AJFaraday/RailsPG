require File.dirname(__FILE__)+'/../test_helper.rb'

class EffectTest < ActiveSupport::TestCase

  def setup
    @skill_effect = AttributeEffect.find_by_name('Acid')
    @player = Character.create(:name => 'Wizard',
                               :character_class => CharacterClass.find_by_name('Wizard'),
                               :level => 5)
  end

  def test_life_span
    effect = Effect.create!(:character_id => @player.id, 
                            :attribute_effect_id => @skill_effect.id,
                            :turns_remaining => 3, 
                            :amount => 2)
    assert @player.effects.include?(effect)
    2.times{effect.turn}
    assert @player.effects.include?(effect)
    effect.turn
    assert !@player.effects.include?(effect)
  end

end
