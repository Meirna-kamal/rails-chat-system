require 'rails_helper'

RSpec.describe Chat, type: :model do
  let(:client_application) { ClientApplication.create!(name: 'Test App') }

  it 'should create a valid chat' do
    chat = Chat.create!(client_application: client_application)
    expect(chat).to be_valid
    expect(chat.chat_number).to be_present
    expect(chat.messages_count).to eq(0)
  end

  it 'should automatically increment chat_number for each new chat' do
    first_chat = Chat.create!(client_application: client_application)
    second_chat = Chat.create!(client_application: client_application)
    expect(second_chat.chat_number).to eq(first_chat.chat_number + 1)
  end
end
