require File.dirname(__FILE__)+'/../test_helper.rb'

class SkillEffectTest < ActiveSupport::TestCase

  def setup
    @fighter = Character.create(:name => 'Fighter',
                                :character_class => CharacterClass.find_by_name('Fighter'),:player => true)
    @wizard = Character.create(:name => 'Wizard',
                               :character_class => CharacterClass.find_by_name('Wizard'),:player => true)
    @enemy = Character.create(:name => 'Snail',
                             :character_class => CharacterClass.find_by_name('Snail'))
  end

  def test_set_skill
    effect = SkillEffect.create!(:name => "Extra Damage", 
                                 :target_trait => 'health', 
                                 :magnitude => -1.5,
                                 :defendable => true, 
                                 :evadeable => true)
    effect.set_skill('character attack')
    effect.save
    assert effect.skill = Skill.find_by_name('character attack')
    assert Skill.find_by_name('character attack').skill_effects.include?(effect) 
  end

end
