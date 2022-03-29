module Chats
  class FindByUser
    attr_reader :user, :limit, :offset

    def initialize(user: , limit: nil, offset: nil)
      @user = user
      @limit = limit || 10
      @offset = offset || 0
    end

    def execute
      chats = scope
        .order(last_message_at: :desc)
        .limit(limit)
        .offset(offset)
        .to_a

      chats.each do |chat|
        chat.current_user=(user)
      end
      
      chats
    end

    private

    def scope
      user.chats.includes(scope_includes)
    end

    def scope_includes
      {participants: :user}
    end
  end	
end
