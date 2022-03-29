class Message < ApplicationRecord
  belongs_to :chat, optional: true
  belongs_to :sender, class_name: 'User', optional: true

  validates :text, presence: true

  def read?
    !!@read
  end

  def read!
    @read = true
  end

  def unread!
    @read = false
  end

  def who_read_ids
    self[:who_read_ids] || []
  end

  def add_who_read!(user)
    return if user.id == sender_id
    
    update_column(:who_read_ids, [].concat(who_read_ids, [user.id]))
  end

  def read_by_user?(user)
    return true if user.id == sender_id

    who_read_ids.include?(user.id)
  end
end
