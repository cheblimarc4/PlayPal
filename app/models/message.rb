class Message < ApplicationRecord
  belongs_to :user
  belongs_to :match
  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to "match_#{match.id}_messages",
                        partial: "messages/message",
                        locals: { message: self }
  end
end
