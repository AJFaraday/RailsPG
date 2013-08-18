require File.dirname(__FILE__)+'/../test_helper.rb'

class SkillEffectTest < ActiveSupport::TestCase

  def setup
    @character = Character.create(:name => 'Player',
                                 :character_class => CharacterClass.find_by_name('Fighter'))
    @enemy = Character.create(:name => 'Snail',
                             :character_class => CharacterClass.find_by_name('Snail'))
  end

  def test_attack
    RSpec
   
    stub_for_successful_effect
    skill = @character.skills.find_by_label('Attack')
    effect = skill.skill_effects[0]
    # character attacks enemy
    effect.use(@character,@enemy)
  end


  def stub_for_successful_effect
    SkillEffect.any_instance.stub(:roll_for_evade).and_return(false)
    #SkillEffect.any_instance.stub(:roll_for_defence).and_return(false)
    #SkillEffect.any_instnace.stub(:roll_for_critical).and_retrn(true)
  end

end
