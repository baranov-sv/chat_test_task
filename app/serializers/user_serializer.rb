class UserSerializer < ActiveModel::Serializer
  attributes :id, :phone, :nickname, :avatar_url
end
