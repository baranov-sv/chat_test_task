class CreateModels < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.text :phone, null: false
      t.text :nickname, null: false
      t.text :avatar_url

      t.timestamps
    end

    add_index :users, :phone, unique: true

    create_table :chats do |t|
      t.datetime :last_message_at, null: false, precision: 6
      t.text :last_message_text,  null: false
      t.integer :last_message_sender_id, null: false

      t.timestamps
    end

    create_table :messages do |t|
      t.integer :chat_id, null: false, index: true
      t.integer :sender_id, null: false
      t.text :text, null: false
      t.datetime :sent_at, null: false, precision: 6
      t.integer :who_read_ids, array: true
      t.jsonb :attachment 

      t.timestamps
    end

    create_table :chat_participants do |t|
      t.integer :user_id, null: false, index: true
      t.integer :chat_id, null: false
      t.integer :unread_message_ids, array: true
      t.integer :unread_messages, null: false, default: 0

      t.timestamps
    end

    add_index :chat_participants, [:chat_id, :user_id], unique: true
  end
end
