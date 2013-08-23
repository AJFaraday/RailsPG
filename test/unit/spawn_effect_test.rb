require File.dirname(__FILE__)+'/../test_helper.rb'

class SpawnEffectTest < ActiveSupport::TestCase

  def setup
    @cabbage = Character.create(:name => 'Snail',
                                :character_class => CharacterClass.find_by_name('Cabbage'), 
                                :level => 5)
    @snail_class = CharacterClass.find_by_name('Snail')
    @cabbage.get_skills
  end

  def test_cabbage_spawns_snail
    assert @cabbage.skills.include?(Skill.find_by_name('cabbage spawn snail'))
    skill_effect = @cabbage.skills.find_by_name('cabbage spawn snail').skill_effects[0]
    skill_effect.use(@cabbage,@cabbage)
    assert_equal 2, Character.count
    assert Character.find_by_character_class_id(@snail_class.id)
  end
  
end
