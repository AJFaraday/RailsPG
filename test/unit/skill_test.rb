require File.dirname(__FILE__)+'/../test_helper.rb'

class SkillTest < ActiveSupport::TestCase

  def test_add_to_classes
    snail_class = CharacterClass.find_by_name('Snail')
    fighter_class = CharacterClass.find_by_name('Fighter')
  
    skill = Skill.find_by_name('snail spit')
    assert_equal 1, skill.character_classes.count
    assert skill.character_classes.include?(snail_class)
    
    skill.add_to_classes("['Fighter',1,true],['Wizard',2,false]")
 
    assert_equal 3, skill.character_classes.count
    assert skill.character_classes.include?(fighter_class)
  end

  def test_use
    character = Character.create(:name => 'Player',
                                 :character_class => CharacterClass.find_by_name('Fighter'),:player => true)
    character.get_skills
    enemy = Character.create(:name => 'Snail',
                             :character_class => CharacterClass.find_by_name('Snail'))
    enemy.get_skills
    skill = character.skills.find_by_label('Attack')
    # character attacks enemy
    skill.use(character,enemy)
  end

  def test_insufficient_skill
    character = Character.create(:name => 'Player',
                                 :character_class => CharacterClass.find_by_name('Fighter'),:player => true)
    character.get_skills
    enemy = Character.create(:name => 'Snail',
                             :character_class => CharacterClass.find_by_name('Snail'))
    enemy.get_skills
    skill = character.skills.find_by_label('Attack')
    # character attacks enemy
    character.update_attribute(:skill, 1)
    initial_health = enemy.health
    message = skill.use(character,enemy)
    assert_equal "Player can't use Attack, not enough skill.", message
    enemy.reload
    assert_equal initial_health, enemy.health
  end

end
