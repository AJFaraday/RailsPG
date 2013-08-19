require File.dirname(__FILE__)+'/../test_helper.rb'

class AttributeEffectTest < ActiveSupport::TestCase

  def setup
    @wizard = Character.create(:name => 'Wizard',
                               :character_class => CharacterClass.find_by_name('Wizard'),
                               :level => 5)
    @enemy = Character.create(:name => 'Snail',
                              :character_class => CharacterClass.find_by_name('Snail'), 
                              :level => 5)
  end

  # reduces defence for a given amount of time
  def test_defence_reduction
    stub_for_successful_attribute_effect
    initial_defence = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find('Strengthen Attack')
    message = skill_effect.use(@enemy,@wizard)
    assert_equal "  Acid: defence -2", message
    assert_equal (initial_defence - 2), @wizard.defence
    @wizard.reload
    2.times do 
      @wizard.finish_turn
      assert_equal (initial_defence - 2), @wizard.defence
    end
    @wizard.finish_turn
    assert_equal initial_defence, @wizard_defence
  end

  # reduces defence for a given amount of time
  def test_defence_reduction_critical
    stub_for_critical_attribute_effect
    initial_defence = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find('Strengthen Attack')
    message = skill_effect.use(@enemy,@wizard)
    assert_equal "  Critical Acid: defence -3", message
    assert_equal (initial_defence - 3), @wizard.defence
    @wizard.reload
    2.times do
      @wizard.finish_turn
      assert_equal (initial_defence - 3), @wizard.defence
    end
    @wizard.finish_turn
    assert_equal initial_defence, @wizard_defence
  end


  def test_defence_reduction_defended
    stub_for_defend_attribute_effect
    initial_defence = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find('Strengthen Attack')
    message = skill_effect.use(@enemy,@wizard)
    assert_equal "  Acid defended"
    assert_equal initial_defence, @wizard.defence
  end

  def test_defence_reduction_evaded
    stub_for_evade_attribute_effect
    initial_defence = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find('Strengthen Attack')
    message = skill_effect.use(@enemy,@wizard)
    assert_equal "  Acid defended"
    assert_equal initial_defence, @wizard.defence
  end

  def test_defence_reduction_stacking
    stub_for_successful_attribute_effect
    initial_defence = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find('Strengthen Attack')
    skill_effect.use(@enemy,@wizard)
    assert_equal (initial_defence - 2), @wizard.defence
    2.times do
      @wizard.finish_turn
      assert_equal (initial_defence - 2), @wizard.defence
    end
    skill_effect.use(@enemy,@wizard)
    1.times do
      @wizard.finish_turn
      assert_equal (initial_defence - 4), @wizard.defence
    end
    skill_effect.use(@enemy,@wizard)
    2.times do
      @wizard.finish_turn
      assert_equal (initial_defence - 2), @wizard.defence
    end
    @wizard.finish_turn
    assert_equal initial_defence, @wizard_defence
  end

  def test_strengthen_non_evadeable
    stub_for_evade_attribute_effect
    initial_attack = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find('Strengthen Attack')
    message = skill_effect.use(@enemy,@wizard)
    assert_equal "  Strengthen Attack: attack +2", message
    assert_equal (initial_attack + 2), @wizard.defence
  end

  def test_strengthen_non_defendable
    stub_for_defend_attribute_effect
    initial_attack = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find('Strengthen Attack')
    message = skill_effect.use(@enemy,@wizard)
    assert_equal "  Strengthen Attack: attack +2", message
    assert_equal (initial_attack + 2), @wizard.defence
  end

  def test_strengthen_critical
    stub_for_critical_attribute_effect
    initial_attack = @wizard.defence
    assert @enemy.skills.include?(Skill.find_by_name('snail acid spit'))
    skill_effect = AttributeEffect.find('Strengthen Attack')
    message = skill_effect.use(@enemy,@wizard)
    assert_equal "  Critical Strengthen Attack: attack +3", message
    assert_equal (initial_attack + 3), @wizard.defence
  end


end
