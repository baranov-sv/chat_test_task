Rails.application.routes.draw do
  resources :chats,  only: [:index] do
    resources :messages, only: [:index, :create]
  end

  resources :messages,  only: [] do
    post :read, on: :member
  end
end
