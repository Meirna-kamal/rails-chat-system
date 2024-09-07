require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  describe 'POST #create' do
    let(:client_application) { ClientApplication.create!(name: 'Test App') }
    it 'creates a new chat and returns chat number' do
      post :create, params: { application_token: client_application.token }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['data']['number']).to be_present
    end
    it 'returns 404 when the application token is invalid' do
      post :create, params: { application_token: 'invalid_token' }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']['code']).to eq(404)
      expect(JSON.parse(response.body)['error']['message']).to eq('Invalid token: Application not found')
    end

  end

  describe 'GET #show' do
    let(:client_application) { ClientApplication.create!(name: 'Test App') }
    let!(:chat) { client_application.chats.create!(messages_count: 5) }

    it 'returns the messages_count for a valid chat' do
      get :show, params: { application_token: client_application.token, chat_number: chat.chat_number }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['messages_count']).to eq(5)
    end

    it 'returns 404 when the application token is invalid' do
      get :show, params: { application_token: 'invalid_token', chat_number: chat.chat_number }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']['code']).to eq(404)
      expect(JSON.parse(response.body)['error']['message']).to eq('Invalid token: Application not found')
    end

    it 'returns 404 when the chat number is invalid' do
      get :show, params: { application_token: client_application.token, chat_number: 999 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']['code']).to eq(404)
      expect(JSON.parse(response.body)['error']['message']).to eq('Invalid chat number: Chat not found')
    end
  end

  describe 'GET #list' do
    let(:client_application) { ClientApplication.create!(name: 'Test App') }
    let!(:chat) { client_application.chats.create! }

    it 'returns chats for a valid application token' do
      get :list, params: { application_token: client_application.token }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data'].first['messages_count']).to eq(0)
    end

    it 'returns 404 for an invalid application token' do
      get :list, params: { application_token: 'invalid_token' }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']['message']).to eq('Invalid token: Application not found')
    end
  end


end

