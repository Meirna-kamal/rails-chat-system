Rails.application.routes.draw do
  
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  post 'applications', to: 'client_applications#create'
  get 'applications/:application_token', to: 'client_applications#show'
  patch 'applications/:application_token', to: 'client_applications#update'

end
