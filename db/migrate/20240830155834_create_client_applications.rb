class CreateClientApplications < ActiveRecord::Migration[7.2]
  def change
    create_table :client_applications do |t|
      t.string :token, limit: 36, null: false
      t.string :name, limit: 255, null: false
      t.integer :chats_count, default: 0, null: false

      t.timestamps
    end

    add_index :client_applications, :token, unique:true ,name: 'client_applications_token_idx'
  end
end