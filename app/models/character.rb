class Character < ActiveRecord::Base

  belongs_to :character_class

  belongs_to :adventure
  belongs_to :game
  belongs_to :current_level, :class_name => 'Level', :foreign_key => 'level_id'
  belongs_to :last_hit_by_character, :class_name => 'Character', :foreign_key => 'last_hit_by_character_id'

  validates_presence_of :name
  validates_presence_of :character_class

  has_many :effects, :dependent => :destroy

  has_many :character_skills, :dependent => :destroy
  has_many :skills, :through => :character_skills


  BARS = ['health', 'skill']
  TRAITS = ['attack', 'defence', 'melee', 'ranged', 'evade', 'luck', 'speed']


  LEVEL_UP_TARGET_MULTIPLIER = 2
  LEVEL_CAP = 20

  # initialize from class

  before_create :initialize_character

  attr_accessor :grid

  def grid
    @grid ||= self.current_level.grid
  end

  def initialize_character
    # TODO limit this to 100
    TRAITS.each do |trait|
      calc_trait = character_class.send("init_#{trait}")
      calc_trait += (self.level - 1) * character_class.send("#{trait}_mod") if self.level > 1
      self.send("#{trait}=", calc_trait)
    end
    BARS.each do |bar|
      calc_bar = character_class.send("init_#{bar}")
      calc_bar += character_class.send("#{bar}_mod") * (self.level - 1) if self.level > 1
      self.send("max_#{bar}=", calc_bar)
    end
    self.full_recover(true)
    self.movement_points = self.speed
    # TODO get skills by explicit definition or player choice
    #self.get_skills
    self.set_init_exp
  end

  def full_recover(skip_save=false)
    self.health = self.max_health
    self.skill = self.max_skill
    self.save unless skip_save
  end

  def set_init_exp
    self.exp = self.level_up_target*(LEVEL_UP_TARGET_MULTIPLIER**(self.level - 1))
    self.level_up_target = self.exp * LEVEL_UP_TARGET_MULTIPLIER
  end

  # Level Methods

  #before_update :check_for_level

  def check_for_level
    until self.exp <= self.level_up_target and self.level <= LEVEL_CAP
      message = self.level_up(false)
      self.level_up_target *= LEVEL_UP_TARGET_MULTIPLIER
      message
    end
  end

  def level_up(save=true)
    self.level += 1
    # TODO get skills by choice, enemies are explicitly set
    #self.get_skills
    TRAITS.each do |trait|
      self.send("#{trait}=", self.send("#{trait}") + character_class.send("#{trait}_mod"))
    end
    BARS.each do |bar|
      self.send("max_#{bar}=", (self.send("max_#{bar}") + character_class.send("#{bar}_mod")))
    end
    self.full_recover()
    return "#{self.name} is now at level #{self.level}"
  end

  def get_skills
    class_skills = character_class_skills.all(:conditions => ["from_level <= ? and automatic = ?", self.level, true])
    class_skills.each do |class_skill|
      self.skills << class_skill.skill
    end
  end

  # General Methods

  def on_door?
    self.current_level.exits.collect { |door| door.coord }.include?(self.coord)
  end


  def use_door
    if self.on_door?
      door = self.current_level.exits.where(:row => self.row, :column => self.column)[0]
      self.update_attributes!(:level_id => door.destination_level_id,
                              :row => door.destination_row,
                              :column => door.destination_column)
      # tell javascript to show things accordingly
      return "#{self.name} has moved to #{self.current_level.name}",
        "$('#character_#{self.id}').appendTo($('table#lvl_#{level_id}')[0].rows[#{self.row-1}].cells[#{self.column-1}]);".html_safe
    else
      raise "Character can not use door when they are not on one."
    end
  end

  def current_turn_js_call
    <<JS
      reset_movable(#{level_id},#{column - 1},#{row - 1},#{movement_points});
JS
  end

  def tooltip
    <<HTML
#{self.name} (Level #{self.level}) - #{self.health}/#{self.max_health} health - #{self.skill}/#{self.max_skill} skill
HTML
  end

  def move(target)
    current_level.character_positions = self.game.characters.find_all_by_level_id(self.level_id).collect { |x| x.coord }
    path = current_level.path_from(self, target)
    # remove start point from path
    path.shift
    return nil if (path.size) > self.movement_points
    path = add_directions(path)
    self.coord = target
    self.update_attributes(:movement_points => movement_points - (path.size))
    path
  rescue => er
    logger.info er.message
    logger.info er.backtrace[0..10]
    nil
  end

  def add_directions(path)
    path.each_with_index do |step_coord, index|
      if index == 0
        prev = self.coord
      else
        prev = path[index - 1]
      end
      if prev[0] == (step_coord[0] - 1)
        path[index] = step_coord << 'right'
      elsif prev[0] == (step_coord[0] + 1)
        path[index] = step_coord << 'left'
      elsif prev[1] == (step_coord[1] - 1)
        path[index] = step_coord << 'down'
      elsif prev[1] == (step_coord[1] + 1)
        path[index] = step_coord << 'up'
      end
    end
    path
  end

  def finish_turn
    messages = effects.collect { |e| e.turn }
    self.update_attributes(:movement_points => self.speed)
    messages << "#{self.name} finished their turn!"
    messages
  end

  # Battle Methods

  def coord
    [self.column, self.row]
  end

  def coord=(value)
    self.column = value[0]
    self.row = value[1]
  end

  def can_see?(target)
    target = Character.find(target) if target.is_a?(Integer)
    (self.level_id == target.level_id and self.game_id == target.game_id and
      grid.line_of_sight_between(self.coord, target.coord))
  end


  def skill_targets(skill)
    skill = Skill.find(skill) if skill.is_a?(Integer)
    hit_player = !skill.offensive
    hit_player = !hit_player if !self.player
    targets = Character.where(:player => hit_player,
                              :level_id => level_id,
                              :game_id => game.id)
    targets.select { |target| (grid.simple_distance_from(self, target) <= skill.range) and
      self.can_see?(target) }
  end


  def use_skill(skill, target_character)
    if alive?
      skill = Skill.find(skill) if skill.is_a?(Integer)
      target_character = Character.find(target_character) if target_character.is_a?(Integer)
      skill.use(self, target_character)
    else
      "#{name} can`t use skills while dead."
    end
  end

  def dead?
    health <= 0
  end

  def kill
    if dead?
      if last_hit_by_character
        experience = Character::TRAITS.collect { |t| self.send(t) }.sum
        messages = ["#{last_hit_by_character.name} killed #{self.name} and gained #{experience} experience."]
        self.destroy
        last_hit_by_character.update_attribute(:exp, last_hit_by_character.exp + experience)
        messages << last_hit_by_character.check_for_level
        # todo
        messages
      else
        messages = ["#{self.name} has died."]
      end
    end
  end

  def alive?
    health > 0
  end

  # used by enemies
  def automatic_turn
    messages = []
    if self.game
      #move towards player
      movement_targets = game.players.select { |x| self.can_see?(x) }
      begin
        if movement_targets.any?
          current_level.character_positions = self.game.characters.find_all_by_level_id(self.level_id).collect { |x| x.coord }
          path = current_level.path_from(self, movement_targets[0])
          # don't include current space
          path.shift
          # don't actually sit on top of players
          path.pop
          path = path.first(self.movement_points)
          if path.any?
            messages << "Snail moves to #{path[-1].inspect}"
            path = self.move(path[-1])
            path = add_directions(path)
          end
        end
      rescue => er
        logger.info "Caught error: #{er.message}"
        logger.info er.backtrace[0..10]
      end
      messages << self.finish_turn
      return messages, {"character_#{self.id}" => path}
    else
      raise "enemies can not move when not in a game."
    end
  end

  # dynamic bar methods
  Character::BARS.each do |bar|
    define_method "#{bar}_percent" do
      ((self.send("#{bar}").to_f/self.send("max_#{bar}")*100.0).to_i)
    end
  end

  # dynamic trait methods
  Character::TRAITS.each do |trait|
    define_method "base_#{trait}" do
      self.send("#{trait}")
    end

    define_method "mod_#{trait}".to_sym do
      amount = self.send("#{trait}_variation")
      return self.send("base_#{trait}") + amount
    end

    define_method "#{trait}_variation".to_sym do
      modifying_effects = self.effects.all(:include => [:attribute_effect],
                                           :conditions => ["skill_effects.target_trait = ?",
                                                           trait.to_s])
      amounts = modifying_effects.collect { |x| x.amount }
      n = 0
      amounts.each do |a|
        n += a
      end
      n
    end
  end


  def to_s
    "#{self.name} - #{self.game.adventure.name} #{self.current_level.name} #{self.coord.inspect}"
  end
end
