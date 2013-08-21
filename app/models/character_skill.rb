class CharacterSkill < ActiveRecord::Base

  belongs_to :character
  belongs_to :skill

  delegate :name, :to => :skill

  validates_presence_of :character
  validates_presence_of :skill
end
