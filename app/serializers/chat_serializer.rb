class ChatSerializer < ActiveModel::Serializer
  attributes :id, :last_message_at, :last_message_text, :unread_messages_count
  has_one :user
  has_one :participant, serializer: UserSerializer
end
