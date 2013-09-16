class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_current_game

  def index
  end

  protected

  def get_current_game
    @current_game = Game.find_by_ip_address_and_current(request.remote_ip, true)
    @running_games = Game.find_all_by_ip_address(request.remote_ip)
  end
 
end
