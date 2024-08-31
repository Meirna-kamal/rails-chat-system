ActiveRecord::Schema[7.2].define(version: 2024_08_31_104110) do
  create_table "chats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "client_application_id", null: false
    t.integer "chat_number", null: false
    t.integer "messages_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_application_id", "chat_number"], name: "client_application_chat_number_idx", unique: true
    t.index ["client_application_id"], name: "index_chats_on_client_application_id"
  end

  create_table "client_applications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "token", limit: 36, null: false
    t.string "name", null: false
    t.integer "chats_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "client_applications_token_idx", unique: true
  end

  add_foreign_key "chats", "client_applications"
end
