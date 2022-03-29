puts 'Delete all'

User.delete_all
Chat.delete_all
ChatParticipant.delete_all
Message.delete_all

puts 'Create example'

user_1 = User.create!(
	phone: '+7-XXX-XXXX-XX-XX',
	nickname: 'Andrey',
	avatar_url: 'https://example.com/andrey.png'
)
user_2 = User.create!(
	phone: '+7-YYY-YYYY-YY-YY',
	nickname: 'Sergey',
	avatar_url: 'https://example.com/sergey.png'
)

last_message_at = Time.now
last_message_text = 'Hello'
last_message_sender_id = user_1.id
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
  user_id: user_1.id,
  chat_id: chat.id,
  unread_messages: 0
)
ChatParticipant.create!(
  user_id: user_2.id,
  chat_id: chat.id,
  unread_message_ids: [message.id],
  unread_messages: 1
)

puts 'Completed'

