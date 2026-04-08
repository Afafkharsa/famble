class Message < ApplicationRecord
  MAX_USER_MESSAGES = 10

  belongs_to :chat
  after_create_commit :broadcast_append_to_chat

  validate :user_message_limit, if: -> { role == "user" }
  validates :content, length: { minimum: 10, maximum: 1000 }, if: -> { role == "user" }

  private

  def user_message_limit
    if chat.messages.where(role: "user").count >= MAX_USER_MESSAGES
      errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
    end
  end

  def broadcast_append_to_chat
    broadcast_append_to chat, target: "messages", partial: "messages/message", locals: { message: self }
  end

end
