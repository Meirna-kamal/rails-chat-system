class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :show, :update]
  
    def create
        begin
            if params[:message_body].blank?
                render json: { error: { code: 400, message: "Message body is required" } }, status: :bad_request
                return
            end

            client_application = ClientApplication.find_by(token: params[:application_token])
            if client_application.nil?
                render json: { error: {code:404,message:"Invalid token: Application not found"}}, status: :not_found
                return
            end

            chat = client_application.chats.find_by(chat_number: params[:chat_number])
            if chat.nil?
                render json: { error: {code:404,message:"Invalid chat number: Chat not found"}}, status: :not_found
                return
            end
  
            message = chat.messages.build(
                message_body: params[:message_body]
            )

            if message.save
                render json: { data: { number: message.message_number } }, status: :created
            else
                render json: { error: { code: 422, message: "Unable to create message. Please check your input and try again." } }, status: :unprocessable_entity
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
            if chat.nil?
                render json: { error: {code:404,message:"Invalid chat number: Chat not found"}}, status: :not_found
                return
            end

            message = chat.messages.find_by(message_number: params[:message_number])
            if message
                render json: { data: { message_body: message.message_body } }, status: :ok
            else
                render json: { error: { code: 404, message: "Invalid message number: Message not found" } }, status: :not_found
            end
        
        rescue StandardError => e
            render json: { error: { code: 500, message: "Internal server error" } }, status: :internal_server_error
        end
    end
    
    def update
        begin
            if params[:message_body].blank?
                render json: { error: { code: 400, message: "Message Body is required" } }, status: :bad_request
                return
            end

            client_application = ClientApplication.find_by(token: params[:application_token])
            if client_application.nil?
                render json: { error: { code: 404, message: "Invalid application token: Application not found" } }, status: :not_found
                return
            end
        
            chat = client_application.chats.find_by(chat_number: params[:chat_number])
            if chat.nil?
                render json: { error: {code:404,message:"Invalid chat number: Chat not found"}}, status: :not_found
                return
            end

            message = chat.messages.find_by(message_number: params[:message_number])
            if message
                if message.update(message_body: params[:message_body])
                    render json: {
                        data: {
                          application_token: client_application.token,
                          chat_number: chat.chat_number,
                          message_number: message.message_number,
                          message_body: message.message_body
                        }
                      }, status: :ok
                else 
                    render json: { error: { code: 422, message: "Unable to update message. Please check your input and try again." } }, status: :unprocessable_entity

                end
            else
                render json: { error: { code: 404, message: "Invalid message number: Message not found" } }, status: :not_found
            end
    
        rescue StandardError => e
            render json: { error: { code: 500, message: "Internal server error" } }, status: :internal_server_error
        end
    end
    
end