class GamesController < ApplicationController

  before_filter :get_game

  # redirects to current game in play
  def index

  end

  def new
    if params[:adventure_id] and @adventure = Adventure.find(params[:adventure_id])
      game = Game.start_adventure(@adventure, request.remote_ip)
      redirect_to play_game_path(game)
    else
      flash[:notice] = "Choose an adventure to start a game."
      redirect_to adventures_path
    end
  end

  def play
    unless @current_game
      flash[:notice] = "You have no current games, choose an adventure to start one."
      redirect_to adventures_path
    end
  end

  def turn

  end

  def get_game
    @game = @current_game
  end

end
