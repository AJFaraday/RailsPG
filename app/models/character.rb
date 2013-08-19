class Character < ActiveRecord::Base

  belongs_to :character_class

  validates_presence_of :name
  validates_presence_of :character_class
 
  has_many :effects
   
  has_many :character_skills
  has_many :skills, :through => :character_skills

  delegate :character_class_skills, :playable, :to => :character_class

  BARS = ['health','skill']
  TRAITS = ['attack','defence','melee','ranged','evade','luck','speed']

  
  LEVEL_UP_TARGET_MULTIPLIER = 2

  # initialize from class

  before_create :initialize_character

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
    self.get_skills
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
    until self.exp <= self.level_up_target
      self.level_up(false)
      self.level_up_target *= LEVEL_UP_TARGET_MULTIPLIER
    end
  end

  def level_up(save=true)
    self.level += 1
    self.get_skills
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
    effects.each{|e|e.turn}
  end

  # Battle Methods

  def skill_options
    skills.collect{|skill| [skill.label,skill.id]}
  end

  def skill_targets(skill)
    skill = Skill.find(skill) if skill.is_a?(Integer)
    hit_player = skill.offensive
    hit_player = !hit_player if !self.playable
    if hit_player
      targets = Character.all.select{|c|!c.playable}
    else
      targets = Character.all.select{|c|c.playable}
    end
    targets.collect{|target|[target.name,target.id]}
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

end
