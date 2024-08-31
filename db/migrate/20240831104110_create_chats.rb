class CreateChats < ActiveRecord::Migration[7.2]
  def change
    create_table :chats do |t|
      t.references :client_application, null: false, foreign_key: true
      t.integer :chat_number, null: false
      t.integer :messages_count, default: 0, null: false

      t.timestamps
    end

    add_index :chats, [:client_application_id, :chat_number], unique: true ,name: "client_application_chat_number_idx" 

  end
end