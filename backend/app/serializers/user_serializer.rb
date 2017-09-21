class UserSerializer < ActiveModel::Serializer
  attributes :id, :email,:games_won
end
