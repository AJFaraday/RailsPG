require File.dirname(__FILE__)+'/../test_helper.rb'

class GridTest < ActiveSupport::TestCase

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
                     :obstacles => [[2, 2],
                                    [4, 2], [4, 3], [4, 4]])
  end

  def test_obstalces_between?
    assert @grid.obstacles_between?([1, 1], [3, 3])
    assert @grid.obstacles_between?([1, 4], [5, 5])
    assert !@grid.obstacles_between?([3, 3], [3, 4])
    assert !@grid.obstacles_between?([1, 3], [3, 5])
  end

  def test_distance_from
    assert_equal 1, @grid.distance_from([1, 1], [1, 2])
    assert_equal 2, @grid.distance_from([1, 3], [2, 4])
    assert_equal 2, @grid.distance_from([2, 4], [1, 3]) # other direction, same distance
    assert_equal 4, @grid.distance_from([1, 3], [3, 5])
  end

  # Probably not going to solve this today
  def test_distance_round_obstacles
    assert_equal 4, @grid.distance_from([1, 1], [3, 3]) # round obstacle, same as arithmetic
    assert_equal 4, @grid.distance_from([3, 2], [5, 2])
    assert_equal 5, @grid.distance_from([3, 2], [5, 3])
    assert_equal 6, @grid.distance_from([3, 5], [5, 1])
  end

  # +-+-+-+-+-+
  # |a|#| | | |
  # +-+-+-+-+-+
  # | |#| |#| |
  # +-+-+-+-+-+
  # | |#| |#| |
  # +-+-+-+-+-+
  # | |#| |#| |
  # +-+-+-+-+-+
  # | | | |#|b|
  # +-+-+-+-+-+
  def test_distance_follows_path
    @grid = Grid.new(:columns => 5,
                     :rows => 5,
                     :obstacles => [[1, 2],
                                    [2, 2], [2, 4],
                                    [3, 2], [3, 4],
                                    [4, 2], [4, 4],
                                    [5, 4]])
    assert_equal 16, @grid.distance_from([1, 1], [5, 5])
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
                     :obstacles => [[2, 2], [2, 4],
                                    [3, 2], [3, 4],
                                    [4, 2], [4, 3], [4, 4]])
    assert_equal 8, @grid.distance_from([1, 3], [5, 3])
  end

  # +-+-+-+
  # |a|#| |
  # +-+-+-+
  # | |#| |
  # +-+-+-+
  # | |#|b|
  # +-+-+-+

  def test_target_unreachable
    @grid = Grid.new(:columns => 3,
                     :rows => 3,
                     :obstacles => [[1, 2], [2, 2], [3, 2]])
    assert_raises RuntimeError.new(Grid::NO_ROUTE_WARNING) do
      @grid.distance_from([1, 1], [3, 3])
    end
  end

  #  1 2 3 4 5 6 7 8 9 10
  # +-+-+-+-+-+-+-+-+-+-+
  # |a| | | | | | | | |b|1     21 round spiral
  # +-+-+-+-+-+-+-+-+-+-+
  # | |#| |#|#|#|#|#|#| |2
  # +-+-+-+-+-+-+-+-+-+-+
  # | |#| |#| | | | |#| |3
  # +-+-+-+-+-+-+-+-+-+-+
  # | |#| |#| |#| | |#| |4
  # +-+-+-+-+-+-+-+-+-+-+
  # | |#| |#| |#| | |#| |5
  # +-+-+-+-+-+-+-+-+-+-+
  # | |#| |#|t|#| | |#| |6
  # +-+-+-+-+-+-+-+-+-+-+
  # | |#| |#|#|#| | |#| |7
  # +-+-+-+-+-+-+-+-+-+-+
  # | |#| | | | | | |#| |8
  # +-+-+-+-+-+-+-+-+-+-+
  # | |#|#|#|#|#|#|#|#| |9
  # +-+-+-+-+-+-+-+-+-+-+
  # |d| | | | | | | | |c|10
  # +-+-+-+-+-+-+-+-+-+-+
  def test_distance_in_spiral
    @grid = Grid.new(:columns => 10,
                     :rows => 10,
                     :obstacles => [
                       [2,2],[2,4],[2,5],[2,6],[2,7],[2,8],[2,9],
                       [3,2],[3,4],[3,9],
                       [4,2],[4,4],[4,6],[4,9],
                       [5,2],[5,4],[5,6],[5,9],
                       [6,2],[6,4],[6,6],[6,9],
                       [7,2],[7,4],[7,5],[7,6],[7,9],
                       [8,2],[8,9],
                       [9,2],[9,3],[9,4],[9,5],[9,6],[9,7],[9,8],[9,9]
                     ])
    t = [6,5]
    a = [1,1]
    b = [1,10]
    c = [10,10]
    d = [10,1]

    assert_equal 23, @grid.distance_from(a, t)
    assert_equal 28, @grid.distance_from(b, t)
    assert_equal 37, @grid.distance_from(c, t)
    assert_equal 32, @grid.distance_from(d, t)

    # reverse direction should work
    assert_equal 23, @grid.distance_from(t, a)
    assert_equal 28, @grid.distance_from(t, b)
    assert_equal 37, @grid.distance_from(t, c)
    assert_equal 32, @grid.distance_from(t, d)
  end
end