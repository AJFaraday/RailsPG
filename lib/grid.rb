class Grid

  require 'line_of_sight'

  attr_accessor :rows
  attr_accessor :columns
  attr_accessor :obstacles


  NO_ROUTE_WARNING = "Backtracked right to the start and still no new options. Target is probably unreachable."

  def initialize(attrs={})
    attrs.each { |att, val| self.send("#{att}=", val) }
  end

  def line_of_sight_between(a,b)
    if !a.is_a?(Array) and a.length != 2 and a.any?{|x|!x.is_a?(Integer)} 
      raise "a: #{a.inspect} is not a valid coordinate"
    end
    if !b.is_a?(Array) and b.length != 2 and b.any?{|x|!x.is_a?(Integer)} 
      raise "b: #{b.inspect} is not a valid coordinate"
    end
    if a[0] < 1 or a[0] > columns or a[1] < 1 or a[1] > rows
      raise "a: #{a.inspect} is out of range (columns: #{columns}, rows: #{rows})"
    end
    if b[0] < 1 or b[0] > columns or b[1] < 1 or b[1] > rows
      raise "b: #{b.inspect} is out of range (columns: #{columns}, rows: #{rows})"
    end
    LineOfSight.between(a,b,obstacles)
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
  attr_accessor :options
  attr_accessor :go_up
  attr_accessor :go_right

  def path_from(a,b)
    distance_from(a,b)
    @visited    
  end

  def distance_from(a, b)
    a = [a.column, a.row] if !a.is_a?(Array) and a.respond_to?(:column) and a.respond_to?(:row)
    b = [b.column, b.row] if !b.is_a?(Array) and b.respond_to?(:column) and b.respond_to?(:row)
    raise "distance_from must accept arrays or models which respond to row and column" unless a.is_a?(Array) and b.is_a?(Array)
    if obstacles_between?(a, b)
      @options = []
      find_route_up_right(a, b)
      find_route_up_left(a, b)
      find_route_down_left(a, b)
      find_route_down_right(a, b)
      return @options.min
    else
      # simple calculation, saves some processing
      # the distance in one direction, plus the distance the other
      simple_distance_from(a, b)
    end
  end

  def simple_distance_from(a, b)
    a = [a.column, a.row] if !a.is_a?(Array) and a.respond_to?(:column) and a.respond_to?(:row)
    b = [b.column, b.row] if !b.is_a?(Array) and b.respond_to?(:column) and b.respond_to?(:row)
    
    # work out nominal route
    x = a
    @visited = [a]
    until x[0] == b[0]
      if b[0] > x[0]
        x = [x[0]+1,x[1]]
      else
        x = [x[0]-1,x[1]]
      end
      @visited << x
    end
    until x[1] == b[1]
      if b[1] > x[1]
        x = [x[0],x[1]+1]
      else
        x = [x[0],x[1]-1]
      end
      @visited << x
    end

    @x_dist = (a[1] - b[1]).abs #just distance
    @y_dist = (a[0] - b[0]).abs
    
    @x_dist + @y_dist
  end

  def find_route_down_right(a, b)
    puts "route finding #{a.inspect} to #{b.inspect} strategy down, right"
    @go_up = false
    @go_right = true
    find_route(a, b)
  end

  def find_route_down_left(a, b)
    puts "route finding #{a.inspect} to #{b.inspect} strategy down, left"
    @go_up = false
    @go_right = false
    find_route(a, b)
  end

  def find_route_up_left(a, b)
    puts "route finding #{a.inspect} to #{b.inspect} strategy up, left"
    @go_up = true
    @go_right = false
    find_route(a, b)
  end

  def find_route_up_right(a, b)
    puts "route finding #{a.inspect} to #{b.inspect} strategy up, right"
    @go_up = true
    @go_right = true
    find_route(a, b)
  end

  def find_route(a, b)
    reset_attributes(a, b)
    until @pos == b
      point_towards(b)
      if @go_right
        do_x_move
      else
        do_y_move
      end
    end
    remove_loops
    @options << @moved
  end

  # try to go to the right row
  def do_x_move
    puts "doing x move from #{@pos.inspect}"
    along_1 = [@pos[0], @pos[1] + @y_move]
    # in the right column or direct move impassable
    if @y_moved == @y_dist or impassable?(along_1)
      #move up or down
      if @go_up
        if passable?(up_1)
          move_up
        elsif passable?(down_1)
          move_down
        else
          if at_dead_end?(@pos)
            do_dead_end_move
          else
            do_y_move
          end
        end
      else
        if passable?(down_1)
          move_down
        elsif passable?(up_1)
          move_up
        else
          if at_dead_end?(@pos)
            do_dead_end_move
          else
            do_y_move
          end
        end
      end
    else
      if passable?(along_1)
        @x_moved += @x_move
        @pos = along_1
        @visited << @pos
        @moved += 1
      else
        do_y_move
      end
    end
  end

  # try to go to the right column
  def do_y_move
    puts "doing y move from #{@pos.inspect}"
    up_or_down_1 = [@pos[0] + @x_move, @pos[1]]
    # in the right row or direct path is impassable
    if @y_moved == @y_dist or impassable?(up_or_down_1)
      #move right or left
      if @go_right
        if passable?(right_1)
          move_right
        elsif passable?(left_1)
          move_left
        else
          if at_dead_end?(@pos)
            do_dead_end_move
          else
            do_x_move
          end
        end
      else
        if passable?(left_1)
          move_left
        elsif passable?(right_1)
          move_right
        else
          if at_dead_end?(@pos)
            do_dead_end_move
          else
            do_x_move
          end
        end
      end
    else
      if passable?(up_or_down_1)
        @pos = up_or_down_1
        @visited << @pos
        @y_moved += @y_move
        @moved += 1
      else
        do_x_move
      end
    end
  end

  def do_dead_end_move
    puts "Dead-end was hit at #{@pos.inspect}"
    visited_index = -1
    @crumb = @visited[visited_index]
    until !at_dead_end?(@crumb)
      @moved -= 1
      visited_index -= 1
      @crumb = @visited[visited_index]

      if @crumb.nil?
        raise "Backtracked right to the start and still no new options. Target is probably unreachable."
      end
    end
    @pos = @crumb
    # remove all but 1 of dead end squares from path
    @visited = @visited.first(@visited.index(@crumb)+2)
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

  def at_dead_end?(x)
    adjacent_to(x).none? { |coord| passable?(coord) }
  end

  def adjacent_to(x)
    [
      [x[0]+1, x[1]],
      [x[0]-1, x[1]],
      [x[0], x[1]+1],
      [x[0], x[1]-1]
    ]
  end

  def reset_attributes(a, b)
    @pos = a
    point_towards(b)
    @x_dist = (b[1] - a[1]) #distance and direction
    @y_dist = (b[0] - a[0])
    @y_moved = 0
    @x_moved = 0
    @moved = 0
    @visited = [a]
  end

  def down_1
    [@pos[0] + 1, @pos[1]]
  end

  def up_1
    [@pos[0] - 1, @pos[1]]
  end

  def right_1
    [@pos[0], @pos[1] + 1]
  end

  def left_1
    [@pos[0], @pos[1] - 1]
  end

  def move_up
    @pos = up_1
    @visited << @pos
    @moved += 1
  end

  def move_down
    @pos = down_1
    @visited << @pos
    @moved += 1
  end

  def move_right
    @pos = right_1
    @visited << @pos
    @moved += 1
  end

  def move_left
    @pos = left_1
    @visited << @pos
    @moved += 1
  end

  def point_towards(target)
    xx_dist = (target[0] - @pos[0]) #distance and direction
    yy_dist = (target[1] - @pos[1])
    @x_move = xx_dist > 0 ? 1 : -1
    @y_move = yy_dist > 0 ? 1 : -1
  end

  def has_loops?
    if @visited.is_a?(Array)
      i = 0
      @visited.any? do |coord|
        tmp_path = @visited.dup
        tmp_path.delete_at(i+1)
        tmp_path.delete_at(i-1)
        result = tmp_path.any? do |cell|
          adjacent_to(coord).include?(cell)
        end
        i += 1
        result
      end
    else
      false
    end
  end

  def remove_loops
    until !self.has_loops?
      i = 0
      @visited.each do |coord|

        tmp_path = @visited.first(i)
        tmp_path.delete_at(-1)
        result = tmp_path.select do |cell|
          adjacent_to(coord).include?(cell)
        end
        if result.any?
          ((@visited.index(result.first) + 1)..(i - 1)).to_a.reverse.each { |x| @visited.delete_at(x) }
          @moved -= ((@visited.index(result.first) + 1)..(i - 1)).to_a.size - 1
          next
        end
        i += 1
      end
    end
  end

end
