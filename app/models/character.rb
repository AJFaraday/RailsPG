class Character < ActiveRecord::Base

  belongs_to :character_class
  
  belongs_to :adventure
  belongs_to :game
  belongs_to :current_level, :class_name => 'Level', :foreign_key => 'level_id'

  validates_presence_of :name
  validates_presence_of :character_class
 
  has_many :effects, :dependent => :destroy
   
  has_many :character_skills, :dependent => :destroy
  has_many :skills, :through => :character_skills


  BARS = ['health','skill']
  TRAITS = ['attack','defence','melee','ranged','evade','luck','speed']

  
  LEVEL_UP_TARGET_MULTIPLIER = 2
  LEVEL_CAP = 20

  # initialize from class

  before_create :initialize_character

  attr_accessor :grid

  def grid
    @grid ||= self.level.grid
  end

  def initialize_character
    # TODO limit this to 100
    TRAITS.each do |trait|
      calc_trait = character_class.send("init_#{trait}")
      calc_trait += (self.level - 1) * character_class.send("#{trait}_mod") if self.level > 1
      self.send("#{trait}=",calc_trait)
    end
    BARS.each do |bar|
      calc_bar = character_class.send("init_#{bar}")
      calc_bar += character_class.send("#{bar}_mod") * (self.level - 1) if self.level > 1
      self.send("max_#{bar}=",calc_bar)
    end
    self.full_recover(true)
    # TODO get skills by explicit definition or player choice
    #self.get_skills
    self.set_init_exp
  end

  def full_recover(skip_save=false)
    self.health = self.max_health
    self.skill  = self.max_skill
    self.save unless skip_save
  end

  def set_init_exp
    self.exp = self.level_up_target*(LEVEL_UP_TARGET_MULTIPLIER**(self.level - 1))
    self.level_up_target = self.exp * LEVEL_UP_TARGET_MULTIPLIER
  end

  # Level Methods

  before_update :check_for_level

  def check_for_level
    until self.exp <= self.level_up_target and self.level <= LEVEL_CAP
      self.level_up(false)
      self.level_up_target *= LEVEL_UP_TARGET_MULTIPLIER
    end
  end

  def level_up(save=true)
    self.level += 1
    # TODO get skills by choice, enemies are explicitly set
    #self.get_skills
    TRAITS.each do |trait|
      self.send("#{trait}=",self.send("#{trait}") + character_class.send("#{trait}_mod"))
    end
    BARS.each do |bar|
      self.send("max_#{bar}=",(self.send("max_#{bar}") + character_class.send("#{bar}_mod")))
    end 
    self.full_recover(true)
  end

  def get_skills
    class_skills = character_class_skills.all(:conditions => ["from_level <= ? and automatic = ?",self.level,true])
    class_skills.each do |class_skill|
      self.skills << class_skill.skill
    end
  end 

  # General Methods
  def finish_turn
    "#{name}: End of turn"
    effects.each{|e|e.turn}
  end

  # Battle Methods

  def coord
    [self.column, self.row]
  end

  def can_see?(target)
    target = Character.find(target) if target.is_a?(Integer)
    (self.level_id == target.level_id and self.game_id == target.game_id and 
     grid.line_of_sight_between(self.coord, target.coord))
  end

  def skill_options
    skills.collect{|skill| [skill.label,skill.id]}
  end

  def skill_targets(skill)
    skill = Skill.find(skill) if skill.is_a?(Integer)
    hit_player = !skill.offensive
    hit_player = !hit_player if !self.player
    targets = Character.where(:player => hit_player, 
                              :level_id => level.id, 
                              :game_id => game.id)
    targets.select{|target|grid.simple_distance_from(self, target) <= skill.range}
  end

  def target_options(skill)
    skill_targets(skill).collect{|target|[target.name, target.id]}
  end

  def use_skill(skill,target_character)
    if alive?
      skill = Skill.find(skill) if skill.is_a?(Integer)
      target_character = Character.find(target_character) if target_character.is_a?(Integer)
      skill.use(self,target_character)
      true
    else
      puts "#{name} can`t use skills while dead."
      false
    end
  end

  def dead?
    health <= 0
  end

  def alive?
    health > 0
  end  

  def automatic_turn
    # skills which could be used now
    skills = skills.select{|skill|self.skill_targets(skill).any?}
    # move targets, if not skills can be used
    targets = level.characters.where(:player => !self.player).select{|x|self.can_see?(x)}
  end

  # dynamic trait methods
  Character::TRAITS.each do |trait|
    define_method "base_#{trait}"do
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
      amounts = modifying_effects.collect{|x|x.amount}
      n = 0
      amounts.each do |a| 
        n += a
      end
      n
    end
  end
end
