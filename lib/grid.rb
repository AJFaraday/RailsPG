class Grid

  attr_accessor :rows
  attr_accessor :columns
  attr_accessor :obstacles


  def initialize(attrs={})
    attrs.each { |att, val| self.send("#{att}=", val) }
  end

  def out_of_range?(coord)
    return true if coord[0] > rows or coord[0] < 1
    return true if coord[1] > columns or coord[1] < 1
    false
  end

  def in_range?(coord)
    !out_of_range?(coord)
  end

  # used in the middle of distance algorithms
  attr_accessor :visited
  attr_accessor :x_dist
  attr_accessor :y_dist
  attr_accessor :x_move
  attr_accessor :y_move
  attr_accessor :x_moved
  attr_accessor :y_moved
  attr_accessor :pos
  attr_accessor :moved # amount moved at all

  def distance_from(a, b)
    a = [a.column, a.row] if !a.is_a?(Array) and a.respond_to?(:column) and a.respond_to?(:row)
    b = [b.column, b.row] if !b.is_a?(Array) and b.respond_to?(:column) and b.respond_to?(:row)
    raise "distance_from must accept arrays or models which respond to row and column" unless a.is_a?(Array) and b.is_a?(Array)
    if obstacles_between?(a, b)
      # algorithm for getting round obstacles
      @x_dist = (b[1] - a[1]) #distance and direction
      @y_dist = (b[0] - a[0])
      @x_move = @x_dist > 0 ? 1 : -1
      @y_move = @y_dist > 0 ? 1 : -1
                             # first up/down, then across
      @y_moved = 0
      @x_moved = 0
      @pos = a
      @moved = 0
      @visited = []
      until @pos == b
        # in the right column
        # or there's something in the way
        if @y_moved == @y_dist or impassable?([@pos[0], @pos[1] + @y_move])
          do_x_move
        else
          do_y_move
        end
        sleep 1
      end
      return @moved
    else
      # simple calculation, saves some processing
      # the distance in one direction, plus the distance the other
      @x_dist = (a[1] - b[1]).abs #just distance
      @y_dist = (a[0] - b[0]).abs
      @x_dist + @y_dist
    end
  end

  def do_x_move
    puts "doing x move from #{@pos.inspect}"
    along_1 = [@pos[0],@pos[1] + @x_move]
    # in the right row or direct move impassable
    if @x_moved == @x_dist or impassable?(along_1)
      #move up or down
      down_1 = [@pos[0] + 1, @pos[1]]
      up_1 = [@pos[0] - 1, @pos[1]]
      if passable?(down_1)
        @pos = down_1
        @moved += 1
      elsif passable?(up_1)
        @pos = up_1
        @moved += 1
      else
        do_dead_end_move
      end
    else
      @x_moved += @x_move
      @pos = along_1
      @moved += 1
    end
    puts "ended at #{@pos.inspect}"
  end

  def do_y_move
    puts "doing y move from #{@pos.inspect}"
    up_or_down_1 = [@pos[0] + @y_move,@pos[1]]
    # in the right column or direct path is impassable
    if @y_moved == @y_dist or impassable?(up_or_down_1)
      #move right or left
      right_1 = [@pos[0], @pos[1] + 1]
      left_1 = [@pos[0], @pos[1] - 1]
      if passable?(right_1)
        @pos = right_1
        @moved += 1
      elsif passable?(left_1)
        @pos = left_1
        @moved += 1
      else
        do_dead_end_move
      end
    else
      @pos = up_or_down_1
      @y_moved += @y_move
      @moved += 1
      puts "ended at #{@pos.inspect}"
    end
  end

  def do_dead_end_move
    raise "Dead-end was hit"
  end

  def obstacles_between?(a, b)
    min_x, max_x = [a[1], b[1]].sort
    min_y, max_y = [a[0], b[0]].sort
    obstacles.any? { |o| o[1] >= min_x and o[1] <= max_x and o[0] >= min_y and o[0] <= max_y }
  end

  def obstacle?(x)
    obstacles.include?(x)
  end

  def impassable?(x)
    if @visited and @visited.is_a?(Array)
      @visited.include?(x) or obstacle?(x) or out_of_range?(x)
    else
      obstacle?(x) or out_of_range?(x)
    end
  end

  def passable?(x)
    !impassable?(x)
  end

end