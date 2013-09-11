class GamesController < ApplicationController

  before_filter :get_game

  # redirects to current game in play
  def index
    redirect_to play_game_path(@current_game)
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

  def move
    @messages = []
    raise "Co ordinate is not valid" unless params[:coord] and params[:coord][0..0] == '[' and params[:coord][-1..-1] == ']'
    @coord = eval params[:coord]
    @path = @game.current_character.move(@coord)
    if @path
      @messages << "#{@game.current_character.name} moves to #{@coord.inspect}"
    else
      @messages << "#{@game.current_character.name} can not move to #{@coord.inspect}."
    end
  end

  def turn
    # skill 
    case params[:skill]
      when "end"
        @messages, @paths = @game.finish_turn
      when "use_door"
        @messages, @extra_js = @game.current_character.use_door
      else
        @skill = @game.current_character.skills.find(params[:skill])
        @messages = @game.current_character.use_skill(@skill,params[:target])
        messages, @paths = @game.finish_turn
        @messages = [@messages, messages].flatten
    end
  end

  def get_game
    @game = @current_game
  end

end
