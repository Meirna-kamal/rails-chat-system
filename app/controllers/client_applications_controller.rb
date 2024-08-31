class ClientApplicationsController < ApplicationController
    
    skip_before_action :verify_authenticity_token, only: [:create, :update, :show]

    def create
        begin
            if params[:name].blank?
                render json: { error: {code:400,message:"Name is required"}}, status: :bad_request
            else
                @client_application = ClientApplication.new(name: params[:name])     
                if @client_application.save
                    render json: { token: @client_application.token }, status: :created
                else
                    render json: { error: "Unable to create application. Please check your input and try again." }, status: :unprocessable_entity
                end
            end
        rescue StandardError => e
            render json: { error: 'Internal server error' }, status: :internal_server_error
        end        
    end
          
    def show
      # Logic to show a specific client application
    end
  
    def update
      # Logic to update a specific client application
    end
  
    private

end