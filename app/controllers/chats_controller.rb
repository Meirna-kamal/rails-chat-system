class ChatsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :show, :list]
  
  def create
    begin
        client_application = ClientApplication.find_by(token: params[:application_token])
        if client_application.nil?
            render json: { error: {code:404,message:"Invalid token: Application not found"}}, status: :not_found
            return
        end

        chat = client_application.chats.build
        if chat.save
            render json: { data: { number: chat.chat_number } }, status: :created
        else
            render json: { error: { code: 422, message: "Unable to create chat. Please check your input and try again." } }, status: :unprocessable_entity
        end
    
    rescue StandardError => e
        render json: { error: { code: 500, message: "Internal server error" } }, status: :internal_server_error
    end
  end


  def show
    begin
        client_application = ClientApplication.find_by(token: params[:application_token])
        if client_application.nil?
            render json: { error: { code: 404, message: "Invalid token: Application not found" } }, status: :not_found
            return
        end

        chat = client_application.chats.find_by(chat_number: params[:chat_number])
        if chat
            render json: { data: { messages_count: chat.messages_count } }, status: :ok
        else
            render json: { error: { code: 404, message: "Invalid chat number: Chat not found" } }, status: :not_found
        end
    
    rescue StandardError => e
        render json: { error: { code: 500, message: "Internal server error" } }, status: :internal_server_error
    end
  end
  
  def list
    begin
        client_application = ClientApplication.find_by(token: params[:application_token])
        if client_application.nil?
          render json: { error: { code: 404, message: "Invalid token: Application not found" } }, status: :not_found
          return
        end

        chat_data = Chat.where(client_application_id: client_application.id)
                .as_json(only: [:chat_number, :messages_count])
        render json: { data: chat_data }, status: :ok

    rescue StandardError => e
        render json: { error: { code: 500, message: "Internal server error" } }, status: :internal_server_error
    end  
  end

end