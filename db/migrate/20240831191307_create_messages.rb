class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.integer :message_number, null: false
      t.text :message_body, null: false

      t.timestamps
    end

  end
end
