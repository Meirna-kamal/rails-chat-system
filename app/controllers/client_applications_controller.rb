class ClientApplicationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :show]

  
  # POST /applications
  def create
      begin
        if params[:name].blank?
          render json: { error: { code: 400, message: "Name is required" } }, status: :bad_request
          return
        end
    
        @client_application = ClientApplication.new(name: params[:name])
    
        if @client_application.save
          render json: { data: { token: @client_application.token } }, status: :created
        else
          render json: { error: { code: 422, message: "Unable to create application. Please check your input and try again." } }, status: :unprocessable_entity
        end

      rescue StandardError => e
        render json: { error: { code: 500, message: "Internal server error" } }, status: :internal_server_error
      end

    end

    
  # GET /applications/:application_token
  def show
    begin

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

    rescue StandardError => e
      render json: { error: { code: 500, message: "Internal server error" } }, status: :internal_server_error
    end

  end
    

  # PATCH /applications/:application_token
  def update
    begin

      @client_application = ClientApplication.find_by(token: params[:application_token])
    
      if @client_application.nil?
        render json: { error: { code: 404, message: "Client application not found" } }, status: :not_found
        return
      end
    
      if params[:name].blank?
        render json: { error: { code: 400, message: "Name is required" } }, status: :bad_request
        return
      end
    
      if @client_application.update(name: params[:name])
        render json: { data: { token: @client_application.token, name: @client_application.name } }, status: :ok
      else
        render json: { error: { code: 422, message: "Unable to update application. Please check your input and try again." } }, status: :unprocessable_entity
      end

    rescue StandardError => e
      render json: { error: { code: 500, message: "Internal server error" } }, status: :internal_server_error
    end

  end
    
end