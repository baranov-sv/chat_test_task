class User < ApplicationRecord
  validates :phone, :nickname, presence: true
  validates :phone, uniqueness: true

  has_many :chat_participants
  has_many :chats, through: :chat_participants
end
