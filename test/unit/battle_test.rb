require File.dirname(__FILE__)+'/../test_helper.rb'

class BattleTest < ActiveSupport::TestCase

  # This is currently mostly for fun! disregard failures here
  def test_snail_battle
    character = Character.create(:name => 'player',
                                 :character_class => CharacterClass.find_by_name('Fighter'),
                                 :player => true)
    character.get_skills
    enemy = Character.create(:name => 'snail',
                             :character_class => CharacterClass.find_by_name('Snail'),
                             :level => 3)
    enemy.get_skills
    puts "player turn"
    # skill options
    options = character.skill_options
    puts options.inspect
    assert_equal 1, options.count
    # target options
    skill_options = options
    targets = character.skill_targets(skill_options[0][1])       
    puts targets.inspect
    assert_equal 1, targets.count
    # use a skill
    enemy_health = enemy.health
    character.use_skill(skill_options[0][1],targets[0][1])
    enemy.reload
    assert enemy.health < enemy_health 

    puts "enemy turn"
    # skill options
    options = enemy.skill_options
    puts options.inspect
    assert_equal 2, options.count
    # target options
    skill_options = options
    targets = enemy.skill_targets(skill_options[0][1]) 
    puts targets.inspect
    assert_equal 1, targets.count
    # use a skill
    character_health = character.health
    enemy.use_skill(skill_options[0][1],targets[0][1])
    character.reload
    #assert character.health < character_health

  end

end
