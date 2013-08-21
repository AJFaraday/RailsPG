# This is to test the loading of adventures and all their sub-objects from adventure definitions
# uses the demo data from /test/example_adventure

require File.dirname(__FILE__)+'/../test_helper.rb'


class LevelLoadTest < ActiveSupport::TestCase

  def setup
    @adventure_path = "test/example_adventure"
  end

  def test_adventure_load
    adventure = Adventure.create_from_folder(@adventure_path)
    assert adventure.valid?
    assert_equal 2, adventure.levels.count

    level = adventure.levels.first
    assert_equal 'space 1', level.name
    assert_equal 2, level.rows
    assert_equal 3, level.columns
    assert_equal 2, level.characters.count
    assert_equal 1, level.enemies.count
    assert_equal 1, level.players.count
    assert_equal 1, level.exits.count
    assert_equal 1, level.entrances.count
    assert level.obstacle_positions.is_a?(Array)
    assert level.obstacle_positions.include?([1,3])

    enemy = level.enemies.first
    assert_equal 'Snail', enemy.character_class.name
    assert_equal 'Enemy', enemy.name
    assert_equal 1, enemy.level

    assert_equal 1, enemy.character_skills.count
    assert_equal 'snail attack', enemy.character_skills[0].name
    assert_equal 1, enemy.character_skills[0].level

    # from csv file, e1
    assert_equal 1, enemy.column
    assert_equal 1, enemy.row

    player = level.players.first
    assert_equal 'Player', player.name
    assert_equal 'Fighter', player.character_class.name
    assert_equal 1, player.level
    assert_equal 2, player.skills.count

    # from csv file, p1
    assert_equal 3, player.column
    assert_equal 2, player.row

    door = level.exits.first
    assert_equal 1, door.column
    assert_equal 2, door.row

    assert_equal level, door.level
    assert_equal adventure.levels[1], door.destination_level


    level = adventure.levels.last
    assert_equal 1, level.entrances.count
    assert_equal 1, level.exits.count
    assert_equal 0, level.players.count
    assert_equal 0, level.enemies.count
    #from space2.csv
    assert_equal 2, level.exits.first.column
    assert_equal 1, level.exits.first.row
  end

end