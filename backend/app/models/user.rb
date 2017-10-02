class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  def games_won
    Game.where(:winner => self).count
  end

  def channel_for(klass)
    return "#{klass.to_s.downcase}_channel_#{self.id}"
  end

end
