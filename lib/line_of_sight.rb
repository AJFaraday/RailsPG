module LineOfSight

  def self.between(a,b,obstacles=[])
    x_dist = b[0] - a[0] # downward distance, negative = upwards
    y_dist = b[1] - a[1] # rightward distance, negative = leftways
    n = x_dist.abs.to_f + y_dist.abs.to_f
    x_div = x_dist / n
    y_div = y_dist / n
    mod_a = a.collect{|n|n=n.to_f+0.5}
    #mod_b = b.collect{|n|n=n.to_f+0.5}
    x = mod_a[0]
    y = mod_a[1]
    current_block = a
    blocks = []
    until current_block == b
      x += x_div
      y += y_div

      current_block = [x.to_i,y.to_i]
      puts current_block.inspect
      if obstacles.include?(current_block)
        puts "a: obstacle at #{current_block.inspect}"
        return false
      end
      if x == x.to_i and obstacles.include?([(x.to_i - 1),y.to_i])
        puts "b: obstacle at #{[(x.to_i - 1),y.to_i].inspect}"
        return false
      end
      if y == y.to_i and obstacles.include?([x.to_i,(y.to_i - 1)])
        puts "c: obstacle at #{[x.to_i,(y.to_i - 1)].inspect}"
        return false
      end
      if x == x.to_i and y == y.to_i and obstacles.include?([(x.to_i - 1),(y.to_i - 1)])
        puts "d: obstacle at #{[(x.to_i - 1),(y.to_i - 1)].inspect}"
      end
    end
    true
  end



end
