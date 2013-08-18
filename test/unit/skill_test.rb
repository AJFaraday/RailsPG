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
                                 :character_class => CharacterClass.find_by_name('Fighter'))
    enemy = Character.create(:name => 'Snail',
                             :character_class => CharacterClass.find_by_name('Snail'))
     
    skill = character.skills.find_by_label('Attack')
    # character attacks enemy
    skill.use(character,enemy)
  end

end
