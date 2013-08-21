class Adventure < ActiveRecord::Base

  has_many :levels
  has_many :characters

end
