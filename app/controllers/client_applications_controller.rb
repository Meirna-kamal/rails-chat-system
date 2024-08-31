class ClientApplicationsController < ApplicationController
    
    skip_before_action :verify_authenticity_token, only: [:create, :update, :show]

    def create
        begin
          if params[:name].blank?
            render json: { error: { code: 400, message: "Name is required" } }, status: :bad_request
          else
            @client_application = ClientApplication.new(name: params[:name])
      
            if @client_application.save
              render json: { data: { token: @client_application.token } }, status: :created
            else
              render json: { error: { code: 422, message: "Unable to create application. Please check your input and try again." } }, status: :unprocessable_entity
            end
        end
        rescue StandardError => e
          render json: { error: { code: 500, message: "Internal server error" } }, status: :internal_server_error
        end
    end
      

    def show
      @client_application = ClientApplication.find_by(token: params[:application_token])
    
      if @client_application
        render json: {
          data: {
            name: @client_application.name,
            chats_count: @client_application.chats_count
          }
        }, status: :ok
      else
        render json: { error: { code: 404, message: "Application not found" } }, status: :not_found
      end
    end
      
    def update

    end
  
    private

end