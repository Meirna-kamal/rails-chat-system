class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :client_application, null: false, foreign_key: true
      t.integer :message_number, null: false
      t.text :message_body, null: false

      t.timestamps
    end

    add_index :messages, [:client_application_id, :chat_id, :message_number], unique: true ,name: "message_in_application_chat_idx" 

  end
end
