require File.dirname(__FILE__)+'/../test_helper.rb'

class RepeatEffectTest < ActiveSupport::TestCase

  def setup
    @ranger = Character.create(:name => 'Ranger',
                               :character_class => CharacterClass.find_by_name('Ranger'),
                               :level => 5,:player => true)
    @ranger.get_skills
    @enemy = Character.create(:name => 'Snail',
                              :character_class => CharacterClass.find_by_name('Snail'), 
                              :level => 5)
    @enemy.get_skills
  end

  def test_poison_added
    stub_for_successful_repeat_effect
    assert @ranger.skills.include?(Skill.find_by_name("ranger poison"))
    skill_effect = Skill.find_by_name("ranger poison").skill_effects[0]
    assert_equal "Poison", skill_effect.name
    message = skill_effect.use(@ranger,@enemy)
    assert_equal "  Poison: health -3\n", message
    assert_equal 1, @enemy.effects.count
    effect = @enemy.effects[0]
    assert_equal -3, effect.amount
  end

  def test_critical_poison_added
    stub_for_critical_repeat_effect
    assert @ranger.skills.include?(Skill.find_by_name("ranger poison"))
    skill_effect = Skill.find_by_name("ranger poison").skill_effects[0]
    message = skill_effect.use(@ranger,@enemy)
    assert_equal "  Critical Poison: health -4\n", message
    assert_equal 1, @enemy.effects.count
    effect = @enemy.effects[0]
    assert_equal -4, effect.amount
  end

  def test_poison_repeats
    stub_for_successful_repeat_effect
    skill_effect = Skill.find_by_name("ranger poison").skill_effects[0]
    skill_effect.use(@ranger,@enemy)
    assert_equal 1, @enemy.effects.count
    effect = @enemy.effects[0]
 
    initial_health = @enemy.health
    @enemy.finish_turn
    @enemy.reload
    assert_equal 1, @enemy.effects.count
    assert_equal (initial_health - 3), @enemy.health
    # effect has finished
    @enemy.finish_turn
    @enemy.reload
    assert_equal 0, @enemy.effects.count
    assert_equal (initial_health - 6), @enemy.health
  end

  def test_poison_one_critical
    stub_for_successful_repeat_effect
    skill_effect = Skill.find_by_name("ranger poison").skill_effects[0]
    skill_effect.use(@ranger,@enemy)
    assert_equal 1, @enemy.effects.count
    effect = @enemy.effects[0]

    stub_for_critical_repeat_effect
    initial_health = @enemy.health
    @enemy.finish_turn
    @enemy.reload
    assert_equal 1, @enemy.effects.count
    assert_equal (initial_health - 5), @enemy.health

    stub_for_successful_repeat_effect
    @enemy.finish_turn
    @enemy.reload
    assert_equal 0, @enemy.effects.count
    assert_equal (initial_health - 8), @enemy.health
  end 

end
