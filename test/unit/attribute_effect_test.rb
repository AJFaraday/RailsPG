require File.dirname(__FILE__)+'/../test_helper.rb'

class AttributeEffectTest < ActiveSupport::TestCase

  def setup
    @wizard = Character.create(:name => 'Wizard',
                               :character_class => CharacterClass.find_by_name('Wizard'),
                               :level => 5, 
                               :player => true)
    @enemy = Character.create(:name => 'Snail',
                              :character_class => CharacterClass.find_by_name('Snail'), 
                              :level => 5)
  end

  # reduces defence for a given amount of time
  def test_defence_reduction
    stub_for_successful_attribute_effect
    initial_defence = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find_by_name('Acid')
    message = skill_effect.use(@enemy,@wizard)
    assert_equal "  Acid: defence -10\n", message
    @wizard.reload
    assert_equal (initial_defence - 10), @wizard.mod_defence
    2.times do 
      @wizard.finish_turn
      @wizard.reload
      assert_equal (initial_defence - 10), @wizard.mod_defence
    end
    @wizard.finish_turn
    @wizard.reload
    assert_equal initial_defence, @wizard.mod_defence
  end

  # reduces defence for a given amount of time
  def test_defence_reduction_critical
    stub_for_critical_attribute_effect
    initial_defence = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find_by_name('Acid')
    message = skill_effect.use(@enemy,@wizard)
    assert_equal "  Critical Acid: defence -15\n", message
    @wizard.reload
    assert_equal (initial_defence - 15), @wizard.mod_defence
    @wizard.reload
    2.times do
      @wizard.finish_turn
      @wizard.reload
      assert_equal (initial_defence - 15), @wizard.mod_defence
    end
    @wizard.finish_turn
    @wizard.reload
    assert_equal initial_defence, @wizard.mod_defence
  end


  def test_defence_reduction_defended
    stub_for_defend_attribute_effect
    initial_defence = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find_by_name('Acid')
    message = skill_effect.use(@enemy,@wizard)
    assert_equal "  Acid defended\n", message
    @wizard.reload
    assert_equal initial_defence, @wizard.defence
  end

  def test_defence_reduction_evaded
    stub_for_evade_attribute_effect
    initial_defence = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find_by_name('Acid')
    message = skill_effect.use(@enemy,@wizard)
    assert_equal "  Acid evaded\n", message
    @wizard.reload
    assert_equal initial_defence, @wizard.defence
  end

  def test_defence_reduction_stacking
    stub_for_successful_attribute_effect
    initial_defence = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find_by_name('Acid')
    skill_effect.use(@enemy,@wizard)
    @wizard.reload
    assert_equal (initial_defence - 10), @wizard.mod_defence
    @wizard.finish_turn
    skill_effect.use(@enemy,@wizard)
    @wizard.finish_turn
    @wizard.reload
    assert_equal 2, @wizard.effects.count
    assert_equal (initial_defence - 20), @wizard.mod_defence
    @wizard.finish_turn
    @wizard.reload
    assert_equal 1, @wizard.effects.count
    assert_equal (initial_defence - 10), @wizard.mod_defence
    2.times{@wizard.finish_turn}
    @wizard.reload
    assert_equal initial_defence, @wizard.mod_defence
  end

  def test_strengthen_non_evadeable
    stub_for_evade_attribute_effect
    initial_attack = @wizard.attack
    assert @wizard.skills.include?(Skill.find_by_name('bolster attack'))
    skill_effect = AttributeEffect.find_by_name('Strengthen Attack')
    message = skill_effect.use(@wizard,@wizard)
    assert_equal "  Strengthen Attack: attack +60\n", message
    @wizard.reload
    assert_equal (initial_attack + 60), @wizard.mod_attack
  end

  def test_strengthen_non_defendable
    stub_for_defend_attribute_effect
    initial_attack = @wizard.attack
    assert @wizard.skills.include?(Skill.find_by_name('bolster attack'))
    skill_effect = AttributeEffect.find_by_name('Strengthen Attack')
    message = skill_effect.use(@wizard,@wizard)
    assert_equal "  Strengthen Attack: attack +60\n", message
    @wizard.reload
    assert_equal (initial_attack + 60), @wizard.mod_attack
  end

  def test_strengthen_critical
    stub_for_critical_attribute_effect
    initial_attack = @wizard.attack
    assert @wizard.skills.include?(Skill.find_by_name('bolster attack'))
    skill_effect = AttributeEffect.find_by_name('Strengthen Attack')
    message = skill_effect.use(@wizard,@wizard)
    assert_equal "  Critical Strengthen Attack: attack +90\n", message
    @wizard.reload
    assert_equal (initial_attack + 90), @wizard.mod_attack
  end


end
