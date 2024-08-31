class ChatsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def create
    begin
        client_application = ClientApplication.find_by(token: params[:application_token])
        if client_application.nil?
            render json: { error: {code:404,message:"Invalid token: Application not found"}}, status: :not_found
            return
        end

        @chat = client_application.chats.build
        if @chat.save
            render json: { data: { number: @chat.chat_number } }, status: :created
        else
            render json: { error: { code: 422, message: "Unable to create chat. Please check your input and try again." } }, status: :unprocessable_entity
        end
    
    rescue StandardError => e
        render json: { error: { code: 500, message: "Internal server error" } }, status: :internal_server_error
    end
  
  end
end