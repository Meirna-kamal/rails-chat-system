require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe 'POST #create' do
    let(:client_application) { ClientApplication.create!(name: 'Test App') }
    let!(:chat) { client_application.chats.create! }

    it 'creates a message with valid parameters' do
      post :create, params: { application_token: client_application.token, chat_number: chat.chat_number, message_body: 'Hello World' }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['data']['number']).to be_present
    end

    it 'returns 400 when message_body is missing' do
      post :create, params: { application_token: client_application.token, chat_number: chat.chat_number }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['error']['message']).to eq('Message body is required')
    end
  end

  describe 'PATCH #update' do
    let(:client_application) { ClientApplication.create!(name: 'Test App') }
    let!(:chat) { client_application.chats.create! }
    let!(:message) { chat.messages.create!(message_body: 'Old Message') }

    it 'updates the message with valid parameters' do
      patch :update, params: {
        application_token: client_application.token,
        chat_number: chat.chat_number,
        message_number: message.message_number,
        message_body: 'Updated Message'
      }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['message_body']).to eq('Updated Message')
    end

    it 'returns 404 when the message number is invalid' do
      patch :update, params: {
        application_token: client_application.token,
        chat_number: chat.chat_number,
        message_number: 999,
        message_body: 'Updated Message'
      }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']['message']).to eq('Invalid message number: Message not found')
    end
  end

  describe 'GET #show' do
    let(:client_application) { ClientApplication.create!(name: 'Test App') }
    let!(:chat) { client_application.chats.create! }
    let!(:message) { chat.messages.create!(message_body: 'Sample Message') }

    it 'returns the message body for a valid request' do
      get :show, params: {
        application_token: client_application.token,
        chat_number: chat.chat_number,
        message_number: message.message_number
      }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['message_body']).to eq('Sample Message')
    end

    it 'returns 404 for an invalid message number' do
      get :show, params: {
        application_token: client_application.token,
        chat_number: chat.chat_number,
        message_number: 999  # Invalid message number
      }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']['message']).to eq('Invalid message number: Message not found')
    end
  end

  describe 'GET #list' do
    let(:client_application) { ClientApplication.create!(name: 'Test App') }
    let!(:chat) { client_application.chats.create! }
    let!(:message1) { chat.messages.create!(message_body: 'First Message') }
    let!(:message2) { chat.messages.create!(message_body: 'Second Message') }

    it 'returns a list of messages for a valid chat' do
      get :list, params: {
        application_token: client_application.token,
        chat_number: chat.chat_number
      }
      expect(response).to have_http_status(:ok)
      messages = JSON.parse(response.body)['data']
      expect(messages.size).to eq(2)
      expect(messages.map { |m| m['message_body'] }).to contain_exactly('First Message', 'Second Message')
    end

    it 'returns 404 when the chat number is invalid' do
      get :list, params: {
        application_token: client_application.token,
        chat_number: 999 # Invalid chat number
      }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']['message']).to eq('Invalid chat number: Chat not found')
    end
  end

  describe 'GET #search' do
    let(:client_application) { ClientApplication.create!(name: 'Test App') }
    let!(:chat) { client_application.chats.create! }
    let!(:message1) { chat.messages.create!(message_body: 'Search this message') }
    let!(:message2) { chat.messages.create!(message_body: 'Do not search this message') }

    it 'returns search results for a valid query' do
      get :search, params: {
        application_token: client_application.token,
        chat_number: chat.chat_number,
        query: 'Search'
      }
      expect(response).to have_http_status(:ok)
      results = JSON.parse(response.body)
      expect(results).to include(
        { 'message_body' => 'Search this message' }
      )
      expect(results).not_to include(
        { 'message_body' => 'Do not search this message' }
      )
    end

    it 'returns 404 when the chat number is invalid' do
      get :search, params: {
        application_token: client_application.token,
        chat_number: 999, # Invalid chat number
        query: 'Search'
      }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']['message']).to eq('Invalid chat number: Chat not found')
    end
end




end

