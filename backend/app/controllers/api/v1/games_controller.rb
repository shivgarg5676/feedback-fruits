class Api::V1::GamesController < ApplicationController
  def index
    if params[:new] == "true"
      render :json => Game.with_new_state
    end
  end
  def show
    render :json => Game.find_by_id(params[:id])
  end
  def new
    game = Game.new(:player1 => current_user)
    render :json => Game
  end
end
