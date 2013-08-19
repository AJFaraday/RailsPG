require File.dirname(__FILE__)+'/../test_helper.rb'

class BarEffectTest < ActiveSupport::TestCase

  def setup
    @fighter = Character.create(:name => 'Fighter',
                                :character_class => CharacterClass.find_by_name('Fighter'))
    @wizard = Character.create(:name => 'Wizard',
                               :character_class => CharacterClass.find_by_name('Wizard'))
    @enemy = Character.create(:name => 'Snail',
                             :character_class => CharacterClass.find_by_name('Snail'))
  end


  def test_attack
    stub_for_successful_bar_effect
    skill = @fighter.skills.find_by_label('Attack')
    effect = skill.skill_effects[0]

    enemy_health = @enemy.health
    # character attacks enemy
    message = effect.use(@fighter,@enemy)
    assert_equal "  Damage: health -5\n", message
    @enemy.reload
    assert_equal (enemy_health - 5), @enemy.health
  end

  def test_critical_attack
    stub_for_critical_bar_effect
    skill = @fighter.skills.find_by_label('Attack')
    effect = skill.skill_effects[0]

    enemy_health = @enemy.health
    # character attacks enemy
    message = effect.use(@fighter,@enemy)
    assert_equal "  Critical Damage: health -7\n", message
    @enemy.reload
    assert_equal 0, @enemy.health #7 damage is done, but it won't go below 0
  end

  def test_evaded_attack
    stub_for_evade_bar_effect
    skill = @fighter.skills.find_by_label('Attack')
    effect = skill.skill_effects[0]

    enemy_health = @enemy.health
    # character attacks enemy
    message = effect.use(@fighter,@enemy)
    assert_equal "  Damage evaded\n", message
    @enemy.reload
    assert_equal (enemy_health), @enemy.health
  end

  def test_defended_attack
    stub_for_defend_bar_effect
    skill = @fighter.skills.find_by_label('Attack')
    effect = skill.skill_effects[0]
                                   
    enemy_health = @enemy.health
    # character attacks enemy
    message = effect.use(@fighter,@enemy)
    assert_equal "  Damage defended\n", message
    @enemy.reload
    assert_equal (enemy_health), @enemy.health
  end

  def test_heal
    stub_for_successful_bar_effect
    skill = @wizard.skills.find_by_label('Heal')
    effect = skill.skill_effects[0]

    @fighter.update_attribute(:health, 1)
    # character attacks enemy
    fighter_health = @fighter.health
    message = effect.use(@wizard,@fighter)
    assert_equal "  Heal: health +6\n", message
    @enemy.reload
    assert_equal (fighter_health + 6), @fighter.health
  end
 
  def test_heal_critical
    stub_for_critical_bar_effect
    skill = @wizard.skills.find_by_label('Heal')
    effect = skill.skill_effects[0]

    @fighter.update_attribute(:health, 1)
    # character attacks enemy
    fighter_health = @fighter.health
    message = effect.use(@wizard,@fighter)
    assert_equal "  Critical Heal: health +9\n", message
    @enemy.reload
    assert_equal (fighter_health + 9), @fighter.health
  end

  def test_heal_only_to_max
    stub_for_successful_bar_effect
    #fighter max health is 30, should not heal beyond 30
    skill = @wizard.skills.find_by_label('Heal')
    effect = skill.skill_effects[0]

    @fighter.update_attribute(:health, 29)
    # character attacks enemy
    message = effect.use(@wizard,@fighter)
    assert_equal "  Heal: health +6\n", message
    @enemy.reload
    assert_equal @fighter.max_health, @fighter.health
  end 


end
