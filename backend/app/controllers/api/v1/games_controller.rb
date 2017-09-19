class Api::V1::GamesController < ApplicationController
  def index
    if params[:new] == "true"
      render :json => Game.get_playing_games(current_user)
    end
  end
end
