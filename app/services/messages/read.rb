module Messages
  class Read
    prepend ServiceModule::Base

    def call(user:, chat:, message:)
      if message.sender_id == user.id
        message.read!
        return success(message)
      end
      
      participant = chat.participants.find{|p| p.user_id == user.id}
      if participant && message.id.in?(participant.unread_message_ids)
        ApplicationRecord.transaction do
          # удаляем сообщение из списка непрочитанных у текущего пользователя
          raw_sql = <<RAW
            unread_message_ids = array_remove(unread_message_ids,  :message_id),
            unread_messages = unread_messages - 1
RAW
          update_scope = ChatParticipant.where(id: participant.id)

          update_scope.update_all([raw_sql, message_id: message.id])
          # 
          message.add_who_read!(user)
        end
      end
      
      # для текущего пользователя помечаем сообщение как прочитанное
      message.read!
      success(message)      
    end
  end
end
