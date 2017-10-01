class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_channel_#{current_user.id}"
  end
  def unsubscribed
    Game.end_games_of(current_user) if current_user.present?
  end

  def joinGame(data)
    Game.join(current_user) if current_user.present?
  end
  def leaveGame(data)
    Game.end_games_of(current_user) if current_user.present?
  end

  def move(data)
    game= Game.with_playing_state.where(:id => data['gameId']).first
    Move.create(:game => game,move_index: data['move'].to_i, player: current_user)
  end


end
