module Messages
  class Create
    prepend ServiceModule::Base
    MAX_RETRY = 1

    def call(user:, chat:, text:, attachment: nil)
      message = Message.new(
        chat_id: chat.id,
        sender_id: user.id, 
        text: text,
        sent_at: Time.current,
        attachment: attachment
      )
            
      retry_count = 0
      begin
        chat.with_lock('FOR UPDATE NOWAIT') do
          message.save!
          # изменяем кеш поля у чата
          chat.update_columns(
            last_message_at: message.sent_at,
            last_message_text: message.text,
            last_message_sender_id: user.id
          )
          # добавляем непрочитанное сообщение всем участникам чата кроме текущего пользователя
          raw_sql = <<RAW
            unread_messages = unread_messages + 1,
            unread_message_ids = array_append(unread_message_ids,  :message_id)
RAW
          update_scope = chat.participants.where.not(user_id: user.id)

          update_scope.update_all([raw_sql, message_id: message.id])
        end

        # для текущего пользователя помечаем сообщение как прочитанное
        message.read!
        success(message)
      rescue ActiveRecord::LockWaitTimeout
        if retry_count < MAX_RETRY
         retry_count += 1
         retry
        else
         raise
        end
      rescue ActiveRecord::Rollback, ActiveRecord::RecordInvalid
        failure(message)
      end
    end
  end
end
