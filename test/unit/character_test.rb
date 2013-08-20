require File.dirname(__FILE__)+'/../test_helper.rb'

class CharacterTest < ActiveSupport::TestCase

  # creating a new character with a class copies it's initial attributes
  def test_initialise_character
    character_class = CharacterClass.find_by_name('Fighter')
    character = Character.create(:name => 'Brian', 
                                 :character_class => character_class,
                                 :player => true)
    
    # character has duplicated initial attributes from character_class
    assert_equal character.max_health, character_class.init_health
    assert_equal character.attack, character_class.init_attack
    assert_equal character.speed, character_class.init_speed

    # basic character setup
    assert_equal 1, character.level
    assert_equal 10, character.exp # This is due to an offest issue, but acceptable
    assert_equal character.health, character.max_health 
    assert_equal character.skill, character.max_skill
  end


  def test_initialise_character_level_2
    character_class = CharacterClass.find_by_name('Fighter')
    character = Character.create(:name => 'Brian',
                                 :character_class => character_class,
                                 :level => 2, :player => true)
    
    # character has duplicated initial attributes from character_class
    assert_equal character.max_health, (character_class.init_health + character_class.health_mod)
    assert_equal character.attack, (character_class.init_attack + character_class.attack_mod)
    assert_equal character.speed, (character_class.init_speed + character_class.speed_mod)

    # basic character setup
    assert_equal 2, character.level
    assert_equal 20, character.exp # This is due to an offest issue, but acceptable
  end

  def test_initialise_character_level_3
    character_class = CharacterClass.find_by_name('Fighter')
    character = Character.create(:name => 'Brian',
                                 :character_class => character_class,
                                 :level => 3,:player => true)
    
    # character has duplicated initial attributes from character_class
    assert_equal character.max_health, (character_class.init_health + (character_class.health_mod * 2))
    assert_equal character.attack, (character_class.init_attack + (character_class.attack_mod * 2))
    assert_equal character.speed, (character_class.init_speed + (character_class.speed_mod * 2))

    # basic character setup
    assert_equal 3, character.level
    assert_equal 40, character.exp # This is due to an offest issue, but acceptable
  end

  def test_initialise_character_level_4
    character_class = CharacterClass.find_by_name('Fighter')
    character = Character.create(:name => 'Brian',
                                 :character_class => character_class,
                                 :level => 4,:player => true)

    # character has duplicated initial attributes from character_class
    assert_equal character.max_health, (character_class.init_health + (character_class.health_mod * 3))
    assert_equal character.attack, (character_class.init_attack + (character_class.attack_mod * 3))
    assert_equal character.speed, (character_class.init_speed + (character_class.speed_mod * 3))

    # basic character setup
    assert_equal 4, character.level
    assert_equal 80, character.exp # This is due to an offest issue, but acceptable
  end

  def test_initialise_character_gets_skills
    character_class = CharacterClass.find_by_name('Fighter')
    character = Character.create(:name => 'Brian',
                                 :character_class => character_class,:player => true)
    assert_equal 1, character.skills.count
    assert character.skills.include?(Skill.find_by_name('character attack'))
  end

  def test_initialise_character_gets_skills_by_level
    character_class = CharacterClass.find_by_name('Snail')
    character = Character.create(:name => 'Snail',
                                 :character_class => character_class,:player => true)
    assert_equal 1, character.skills.count
    assert character.skills.include?(Skill.find_by_name('snail attack'))
    # at level 3 there will be two attacks
    character = Character.create(:name => 'Snail',
                                 :character_class => character_class, 
                                 :level => 3)
    assert_equal 2, character.skills.count
    assert character.skills.include?(Skill.find_by_name('snail attack'))
    assert character.skills.include?(Skill.find_by_name('snail spit'))
  end
  
  def test_level_up
    character_class = CharacterClass.find_by_name('Snail')
    character = Character.create(:name => 'Snail',
                                 :character_class => character_class,:player => true)
    assert_equal 1, character.level
    assert_equal 10, character.exp 
    assert_equal 20, character.level_up_target
    # run out of health and skill
    character.health = 1
    character.skill = 1
    # increase experience
    character.exp = 21
    character.save
    # check that it worked
    assert_equal 2, character.level
    assert_equal 40, character.level_up_target
    assert_equal character.max_health, character.health
    assert_equal character.max_skill, character.skill
    # level up again
    character.update_attribute(:exp, 45)
    # check this one worked
    assert_equal 3, character.level
    assert_equal 80, character.level_up_target
    # not enough to level up
    character.update_attribute(:exp, 75)
    # nothing changed
    assert_equal 3, character.level
    assert_equal 80, character.level_up_target

  end



end
