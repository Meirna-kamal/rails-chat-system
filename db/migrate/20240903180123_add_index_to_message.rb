class AddIndexToMessage < ActiveRecord::Migration[7.2]
  def change
    add_index :messages, [:message_number, :chat_id], unique: true ,name: "chat_id_message_number_idx" 
  end
end