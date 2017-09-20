class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_channel_#{current_user.id}"
  end
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def joinGame(data)
    if current_user
      Game.join(current_user)
    end
  end
  def endGame(data)

  end

  def move(data)
    game= Game.with_playing_state.where(:id => data['gameId']).first
    game.move(data, current_user)
  end


end
