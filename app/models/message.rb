class Message < ApplicationRecord
  belongs_to :chat

  before_validation :set_message_number, on: :create

  validates :message_number, presence: true, uniqueness: { scope: [:chat_id] }
  validates :message_number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :message_body, presence: true

  private
  def set_message_number
    Message.transaction do
      max_message_number = Message.where(chat_id: chat_id)
                            .lock("FOR UPDATE")
                            .maximum(:message_number) || 0
      self.message_number = max_message_number + 1
    end
  end

end