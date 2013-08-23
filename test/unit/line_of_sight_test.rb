require File.dirname(__FILE__)+'/../test_helper.rb'

class LineOfSightTest < ActiveSupport::TestCase

  # LineOfSight.between(a,b,obstacles)
  #
  # a is a pair of co-ordinates [row, column]
  # b is a pair of co-ordinates [row, column]
  # obstacles is an array of pairs of co-ordinates
  #
  # All co-ordinates start at [1,1], top left

  # No obstacles
  #
  # +-+-+
  # | |b|
  # +-+-+
  # | | |
  # +-+-+
  # |a| |
  # +-+-+
  #
  def test_line_of_sight_with_no_obstacles
    assert LineOfSight.between([3,1],
                               [1,2])
  end
  # No obstacles
  #
  # +-+-+
  # | | |
  # +-+-+
  # | | |
  # +-+-+
  # |a|b|
  # +-+-+
  #
  def test_line_of_sight_next_door
    assert LineOfSight.between([3,1],
                               [3,2])
  end

  #
  # +-+-+
  # | |b|
  # +-+-+
  # |#| |
  # +-+-+
  # |a| |
  # +-+-+
  #
  def test_no_line_of_sight_obstacle_1
    assert !LineOfSight.between([3,1],
                                [1,2],
                                [[2,1]])
  end

  #
  # +-+-+
  # | |b|
  # +-+-+
  # | |#|
  # +-+-+
  # |a| |
  # +-+-+
  #
  def test_no_line_of_sight_obstacle_2
    assert !LineOfSight.between([3,1],
                                [1,2],
                                [[2,2]])
  end

  #
  # +-+-+
  # | |b|
  # +-+-+
  # |#|#|
  # +-+-+
  # |a| |
  # +-+-+
  #
  def test_no_line_of_sight_two_obstacles
    assert !LineOfSight.between([3,1],
                                [1,2],
                                [[2,1],[2,2]])
  end

  #
  # +-+-+
  # |#|b|
  # +-+-+
  # | | |
  # +-+-+
  # |a|#|
  # +-+-+
  #
  def test_line_of_sight_two_obstacles
    assert LineOfSight.between([3,1],
                               [1,2],
                               [[1,1],[3,2]])
  end

  #
  # +-+-+
  # |#|b|
  # +-+-+
  # | | |
  # +-+-+
  # |a| |
  # +-+-+
  #
  def test_line_of_sight_obstacle_not_in_the_way
    assert LineOfSight.between([3,1],
                               [1,2],
                               [[1,1]])
  end

  #
  # +-+-+
  # | |b|
  # +-+-+
  # | | |
  # +-+-+
  # |a|#|
  # +-+-+
  #
  def test_line_of_sight_obstacle_not_in_the_way_2
    assert LineOfSight.between([3,1],
                               [1,2],
                               [[3,2]])
  end

  # This /may/ show up a weakness in the algoithm
  # But I don't think they should be able to see through this gap
  #
  # +-+-+
  # |#|b|
  # +-+-+
  # |a|#|
  # +-+-+
  #
  def test_line_of_sight_diagonal
    assert !LineOfSight.between([2,1],
                                [1,2],
                                [[1,1],[2,2]])
  end



end
