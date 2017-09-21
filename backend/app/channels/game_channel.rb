class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_channel_#{current_user.id}"
  end
  def unsubscribed
    Game.leave_game(current_user) if current_user.present?
  end

  def joinGame(data)
    Game.join(current_user) if current_user.present?
  end
  def leaveGame(data)
    Game.leave_game(current_user) if current_user.present?
  end

  def move(data)
    game= Game.with_playing_state.where(:id => data['gameId']).first
    game.move(data, current_user)
  end


end
