require 'rails_helper'

RSpec.describe ClientApplicationsController, type: :controller do
  describe 'POST #create' do

    context 'with valid parameters' do
      it 'creates a new client application and returns the token' do
        post :create, params: { name: 'Test App' }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['data']['token']).to be_present
      end
    end

    context 'with missing name parameter' do
      it 'returns an error when name is missing' do
        post :create, params: {}
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']['message']).to eq('Name is required')
      end
    end

  end

  describe 'PATCH #update' do
  let!(:client_application) { ClientApplication.create!(name: 'Original Name') }

    context 'with valid parameters' do
      it 'updates the client application and returns the updated details' do
        patch :update, params: { application_token: client_application.token, name: 'Updated Name' }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data']['token']).to eq(client_application.token)
        expect(json_response['data']['name']).to eq('Updated Name')
        expect(client_application.reload.name).to eq('Updated Name')
      end
    end

    context 'with missing application_token' do
      it 'returns an error when the client application is not found' do
        patch :update, params: { application_token: 'invalid_token', name: 'New Name' }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']['message']).to eq('Client application not found')
      end
    end

    context 'with missing name parameter' do
      it 'returns an error when name is missing' do
        patch :update, params: { application_token: client_application.token }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']['message']).to eq('Name is required')
      end
    end

  end

  describe 'GET #show' do
    let!(:client_application) { ClientApplication.create!(name: 'Test App') }

    context 'with a valid token' do
      it 'returns the client application details' do
        get :show, params: { application_token: client_application.token }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        
        expect(json_response['data']['name']).to eq(client_application.name)
        expect(json_response['data']['chats_count']).to eq(client_application.chats_count)
      end
    end

    context 'with an invalid token' do
      it 'returns an error when the client application is not found' do
        get :show, params: { application_token: 'invalid_token' }
        
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']['message']).to eq('Application not found')
      end
    end
  end

end
