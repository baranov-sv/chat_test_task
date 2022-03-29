class ChatParticipant < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :chat, optional: true

  def unread_message_ids
  	self[:unread_message_ids] || []
  end
end
