Rails.application.routes.draw do
  
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  post 'applications', to: 'client_applications#create'
  patch 'applications/:application_token', to: 'client_applications#update'
  get 'applications/:application_token', to: 'client_applications#show'

  post 'applications/:application_token/chats', to: 'chats#create'
  get 'applications/:application_token/chats', to: 'chats#list'
  get 'applications/:application_token/chats/:chat_number', to: 'chats#show'

  post 'applications/:application_token/chats/:chat_number/messages', to: 'messages#create'
  get 'applications/:application_token/chats/:chat_number/messages', to: 'messages#list'
  get 'applications/:application_token/chats/:chat_number/messages/:message_number', to: 'messages#show'
  patch 'applications/:application_token/chats/:chat_number/messages/:message_number', to: 'messages#update'

  get 'messages/search', to: 'messages#search'
end
