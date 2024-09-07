require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:chat) { Chat.create!(client_application: ClientApplication.create!(name: 'Test App')) }

  it 'should create a valid message' do
    message = Message.create!(chat: chat, message_body: 'Hello, World!')
    expect(message).to be_valid
    expect(message.message_number).to be_present
  end

  it 'should validate presence of message_body' do
    message = Message.new(chat: chat, message_number: 1)
    expect(message).not_to be_valid
    expect(message.errors[:message_body]).to include("can't be blank")
  end

  it 'should automatically increment message_number for each new message' do
    first_message = Message.create!(chat: chat, message_body: 'First message')
    second_message = Message.create!(chat: chat, message_body: 'Second message')
    expect(second_message.message_number).to eq(first_message.message_number + 1)
  end

end
