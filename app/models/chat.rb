class Chat < ApplicationRecord
  has_many :messages, dependent: :delete_all
  has_many :participants, class_name: 'ChatParticipant', dependent: :delete_all
  belongs_to :last_message_sender, class_name: 'User', optional: true

  attr_reader :user, :participant

  def group?
    unless defined?(@group)
      @group = participants.size > 2
    end
    
    @group
  end

  # устанавливает текущего пользователя чата и зависимые виртуальный аттрибуты
  def current_user=(user)
    p1, p2 = participants.partition{|p| p.user_id == user.id}.map(&:first)
    @user = p1&.user
    @participant = p2&.user
    @unread_messages_count = p1&.unread_messages
  end

  def unread_messages_count
    @unread_messages_count || 0
  end
end
