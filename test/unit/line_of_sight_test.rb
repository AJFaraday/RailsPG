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
    assert LineOfSight.between([3, 1],
                               [1, 2])
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
    assert LineOfSight.between([3, 1],
                               [3, 2])
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
    assert !LineOfSight.between([3, 1],
                                [1, 2],
                                [[2, 1]])
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
    assert !LineOfSight.between([3, 1],
                                [1, 2],
                                [[2, 2]])
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
    assert !LineOfSight.between([3, 1],
                                [1, 2],
                                [[2, 1], [2, 2]])
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
    assert LineOfSight.between([3, 1],
                               [1, 2],
                               [[1, 1], [3, 2]])
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
    assert LineOfSight.between([3, 1],
                               [1, 2],
                               [[1, 1]])
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
    assert LineOfSight.between([3, 1],
                               [1, 2],
                               [[3, 2]])
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
    assert !LineOfSight.between([2, 1],
                                [1, 2],
                                [[1, 1], [2, 2]])
  end


  def test_line_of_sight_diagonal_1_obstacle
    #
    # +-+-+
    # |#|b|
    # +-+-+
    # |a| |
    # +-+-+
    #
    assert !LineOfSight.between([2, 1],
                                [1, 2],
                                [[1, 1]])
    # +-+-+
    # | |b|
    # +-+-+
    # |a|#|
    # +-+-+
    assert !LineOfSight.between([2, 1],
                                [1, 2],
                                [[2, 2]])
  end

  # +-+-+-+-+-+-+-+-+
  # |a| |#|#|#|#|#|#|
  # +-+-+-+-+-+-+-+-+
  # | | | |#|#|#|#|#|
  # +-+-+-+-+-+-+-+-+
  # |#| | | |#|#|#|#|
  # +-+-+-+-+-+-+-+-+
  # |#|#| | | |#|#|#|
  # +-+-+-+-+-+-+-+-+
  # |#|#|#| | | |#|#|
  # +-+-+-+-+-+-+-+-+
  # |#|#|#|#| | | |#|
  # +-+-+-+-+-+-+-+-+
  # |#|#|#|#|#| | | |
  # +-+-+-+-+-+-+-+-+
  # |#|#|#|#|#|#| |b|
  # +-+-+-+-+-+-+-+-+

  # this is to test how much performance will be lost to a
  # large array of obstacles
  def test_line_of_sight_large_arena_with_obstacles
    # the above with no obstacles
    a = Benchmark.measure do
      assert LineOfSight.between([1, 1],
                                 [8, 8],
                                 [
                                   [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8],
                                   [2, 4], [2, 5], [2, 6], [2, 7], [2, 8],
                                   [3, 1], [3, 5], [3, 6], [3, 7], [3, 8],
                                   [4, 1], [4, 2], [4, 6], [4, 7], [4, 8],
                                   [5, 1], [5, 2], [5, 3], [5, 7], [5, 8],
                                   [6, 1], [6, 2], [6, 3], [6, 4], [6, 8],
                                   [7, 1], [7, 2], [7, 3], [7, 4], [7, 5],
                                   [8, 1], [8, 2], [8, 3], [8, 4], [8, 5], [8, 6]
                                 ])
    end
    puts a
  end

  def test_line_of_sight_large_arena
    # the above with no obstacles
    a = Benchmark.measure do
      assert LineOfSight.between([1, 1],
                                 [8, 8],
                                 [])
    end
    puts a
  end


end
