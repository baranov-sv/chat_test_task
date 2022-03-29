class ChatsController < ApplicationController  
 
  def index
    chats = Chats::FindByUser.new(user: current_user).execute

    render json: chats
  end
end

# curl http://localhost:3000/chats
