class Chat < ApplicationRecord
  belongs_to :client_application
  before_validation :set_chat_number, on: :create

  validates :chat_number, presence: true, uniqueness: { scope: :client_application_id }
  validates :messages_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :chat_number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  private
  def set_chat_number
    Chat.transaction do
      max_chat_number = Chat.where(client_application_id: client_application_id)
                            .lock("FOR UPDATE")
                            .maximum(:chat_number) || 0
      self.chat_number = max_chat_number + 1
    end
  end
    
end