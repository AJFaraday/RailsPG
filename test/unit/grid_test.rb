require File.dirname(__FILE__)+'/../test_helper.rb'

class EffectTest < ActiveSupport::TestCase

  # +-+-+-+-+-+
  # | | | | | |
  # +-+-+-+-+-+
  # | |#| | | |
  # +-+-+-+-+-+
  # | | | | | |
  # +-+-+-+-+-+
  # | |#|#|#| |
  # +-+-+-+-+-+
  # | | | | | |
  # +-+-+-+-+-+
  def setup
    @grid = Grid.new(:columns => 5,
                     :rows => 5,
                     :obstacles => [[2,2],
                                    [4,2], [4,3], [4,4]])
  end

  def test_obstalces_between?
    assert @grid.obstacles_between?([1,1],[3,3])
    assert @grid.obstacles_between?([1,4],[5,5])
    assert !@grid.obstacles_between?([3,3],[3,4])
    assert !@grid.obstacles_between?([1,3],[3,5])
  end

  def test_distance_from
    assert_equal 1, @grid.distance_from([1,1], [1,2])
    assert_equal 2, @grid.distance_from([1,3], [2,4])
    assert_equal 2, @grid.distance_from([2,4], [1,3]) # other direction, same distance
    assert_equal 4, @grid.distance_from([1,3], [3,5])
  end

  # Probably not going to solve this today
  def test_distance_round_obstacles
    #assert_equal 4, @grid.distance_from([1,1], [3,3]) # round obstacle, same as arithmetic
    assert_equal 4, @grid.distance_from([3,2], [5,2])
    assert_equal 5, @grid.distance_from([3,2], [5,3])
    assert_equal 6, @grid.distance_from([3,5], [5,3])
  end

  # +-+-+-+-+-+
  # | | |a| | |
  # +-+-+-+-+-+
  # | |#| |#| |
  # +-+-+-+-+-+
  # | |#| |#| |
  # +-+-+-+-+-+
  # | |#|#|#| |
  # +-+-+-+-+-+
  # | | |b| | |
  # +-+-+-+-+-+
  def test_distance_with_trap
    @grid = Grid.new(:columns => 5,
                     :rows => 5,
                     :obstacles => [[2,2], [2,4],
                                    [3,2], [3,4],
                                    [4,2], [4,3], [4,4]])
    assert 8, @grid.distance_between([1,3],[5,3])
  end


end