# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_29_072225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chat_participants", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "chat_id", null: false
    t.integer "unread_message_ids", array: true
    t.integer "unread_messages", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_id", "user_id"], name: "index_chat_participants_on_chat_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_chat_participants_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.datetime "last_message_at", precision: 6, null: false
    t.text "last_message_text", null: false
    t.integer "last_message_sender_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "chat_id", null: false
    t.integer "sender_id", null: false
    t.text "text", null: false
    t.datetime "sent_at", precision: 6, null: false
    t.integer "who_read_ids", array: true
    t.jsonb "attachment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "phone", null: false
    t.text "nickname", null: false
    t.text "avatar_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["phone"], name: "index_users_on_phone", unique: true
  end

end
