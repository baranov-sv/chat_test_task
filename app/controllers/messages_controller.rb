class MessagesController < ApplicationController  
 
  def index
    messages = Messages::FindByUserChat.new(user: current_user, chat: current_chat).execute

    render json: messages
  end

  def create
    permitted_params = message_params
    result = Messages::Create.new.call(
      user: current_user,
      chat: current_chat,
      text: permitted_params[:text],
      attachment: permitted_params[:attachment]
    )

    if result.success?
     render json: result.value 
    else
      unprocessable_entity(result.error.to_s)
    end
  end

  def read
    result = Messages::Read.new.call(
      user: current_user,
      chat: current_chat,
      message: current_message,
    )

    render json: result.value
  end

  private

  def current_chat
    return @current_chat if defined? @current_chat

    chat_id = current_message ? current_message.chat_id : params[:chat_id]
    
    # проверяем имеет ли текущий пользователь доступ к чату
    @current_chat = current_user.chats.find(chat_id)
  end

  def current_message
    return @current_message if defined? @current_message

    if params.include?(:id)
      @current_message = Message.find(params[:id])
    else
      @current_message = nil
    end
  end

  def message_params
    params.require(:message).permit(:text, :attachment)
  end
end

# curl http://localhost:3000/chats/1/messages
# curl -X POST http://localhost:3000/chats/1/messages -d message[text]=Bla
# curl -X POST http://localhost:3000/messages/4/read
