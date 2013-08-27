class AdventuresController < ApplicationController
 
  def index
    @adventures = Adventure.order("NAME ASC")
  end

end
