require 'rails_helper'

# автоматизация ручного прогона разных кейсов
RSpec.describe 'all' do
  before {
    @user_1 = create(:user)
    @user_2 = create(:user)

    last_message_at = Time.now
    last_message_text = 'Hello'
    last_message_sender_id = @user_1.id
    chat = Chat.create!(
      last_message_at: last_message_at,
      last_message_text: last_message_text,
      last_message_sender_id: last_message_sender_id
    )

    message = Message.create!(
      chat_id: chat.id,
      sender_id: last_message_sender_id, 
      text: last_message_text,
      sent_at: last_message_at,
      attachment: {type: 'picture', name: 'image.png', url: 'https://example.com/image.png'}
    )

    ChatParticipant.create!(
      user_id: @user_1.id,
      chat_id: chat.id,
      unread_messages: 0
    )
    ChatParticipant.create!(
      user_id: @user_2.id,
      chat_id: chat.id,
      unread_message_ids: [message.id],
      unread_messages: 1
    )
  }
  
  describe 'Chats::FindByUser' do
    it 'should be ok' do
      chat = Chats::FindByUser.new(user: @user_1).execute.first
      expect(chat).to be_present
      expect(chat.unread_messages_count).to eq 0
      expect(chat.user).to eq @user_1
      expect(chat.participant).to eq @user_2
      #
      chat = Chats::FindByUser.new(user: @user_2).execute.first
      expect(chat).to be_present
      expect(chat.unread_messages_count).to eq 1
      expect(chat.user).to eq @user_2
      expect(chat.participant).to eq @user_1
    end 
  end

  describe 'Messages::FindByUserChat' do
    it 'should be ok' do
      chat = Chats::FindByUser.new(user: @user_1).execute.first
      message = Messages::FindByUserChat.new(user: @user_1, chat: chat).execute.first
      expect(message).to be_present
      expect(message).to be_read
      #
      chat = Chats::FindByUser.new(user: @user_2).execute.first
      message = Messages::FindByUserChat.new(user: @user_2, chat: chat).execute.first
      expect(message).to be_present
      expect(message).not_to be_read
    end
  end

  describe 'Messages::Read' do
    it 'should be ok' do
      chat = Chats::FindByUser.new(user: @user_2).execute.first
      expect(chat.unread_messages_count).to eq 1
      message = Messages::FindByUserChat.new(user: @user_2, chat: chat).execute.first
      expect(message).not_to be_read
      expect(message.read_by_user?(@user_2)).to be_falsey
      result = Messages::Read.new.call(user: @user_2, chat: chat, message: message)
      expect(result).to be_success      
      chat = Chats::FindByUser.new(user: @user_2).execute.first
      # уменьшает кол-во непрочитанных сообщений пользователя
      expect(chat.unread_messages_count).to eq 0
      message = Messages::FindByUserChat.new(user: @user_2, chat: chat).execute.first
      # помечает сообщение прочитанным пользователем
      expect(message).to be_read
      # добавляет пользователя в список тех кто прочитал сообщение
      expect(message.read_by_user?(@user_2)).to be_truthy
    end
  end

  describe 'Messages::Create' do
    it 'should be ok' do
      chat = Chats::FindByUser.new(user: @user_2).execute.first
      expect(chat.unread_messages_count).to eq 1
      messages = Messages::FindByUserChat.new(user: @user_2, chat: chat).execute
      expect(messages.size).to eq 1
      text = 'bla bla bla'
      result = Messages::Create.new.call(user: @user_1, chat: chat, text: text)
      expect(result).to be_success
      # создает новое сообщение в чате
      messages = Messages::FindByUserChat.new(user: @user_2, chat: chat).execute
      expect(messages.size).to eq 2
      chat = Chats::FindByUser.new(user: @user_2).execute.first
      # увеличивает кол-во непрочитанных сообщений пользователя
      expect(chat.unread_messages_count).to eq 2      
      # изменяет кещирующие поля в чате
      expect(chat.last_message_text).to eq result.value.text
      expect(chat.last_message_at).to eq result.value.sent_at
      expect(chat.last_message_sender_id).to eq result.value.sender_id
    end
  end

end
