class GameController < ApplicationController

  # redirects to current game in play
  def index
    if @current_game
      redirect_to play_game_path(@current_game)
    else
      flash[:notice] = "You have no current games, choose an adventure to start one."
      redirect_to adventures_path
    end
  end

  def play

  end

  def turn

  end

end
