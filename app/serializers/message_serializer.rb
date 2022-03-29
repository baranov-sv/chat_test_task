class MessageSerializer < ActiveModel::Serializer
  attributes :id, :sent_at, :text, :attachment
  attribute :read
  has_one :sender, serializer: UserSerializer

  def read
    object.read?
  end
end
