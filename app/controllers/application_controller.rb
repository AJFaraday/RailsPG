class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_current_game

  def index
  end

  def get_current_game
    @current_game = Game.find_by_ip_address_and_current(request.remote_ip, true)
  end
 
end
