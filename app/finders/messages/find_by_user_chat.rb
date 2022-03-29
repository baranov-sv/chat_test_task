module Messages
  class FindByUserChat
    attr_reader :user, :chat, :limit, :offset

    def initialize(user:, chat:, limit: nil, offset: nil)
      @user = user
      @chat = chat
      @limit = limit || 20
      @offset = offset || 0
    end

    def execute
      messages = scope
        .order(sent_at: :desc)
        .limit(limit)
        .offset(offset)
        .to_a

      unless messages.empty?
        unread_message_ids = chat.participants.find_by(user_id: user.id)&.unread_message_ids || []
        messages.each do |message|
          # проверяем прочитал ли текущий пользователь сообщение
          message.id.in?(unread_message_ids) ? message.unread! : message.read!
        end
      end

      messages
    end

    private

    def scope
      chat.messages.includes(scope_includes)
    end

    def scope_includes
      [:sender]
    end
  end
end
