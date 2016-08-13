Rails.application.routes.draw do

  resources :comments
  #get  'send_messages'=> "events#send_messages", as: "/send_messages"
  #get  'receive_messages'=> "events#receive_messages", as: "/receive_messages"
  resources :events, only: [:index,:new,:create, :show] do
  	collection do
  		match 'send_messages', via: :get, as: "/send_messages"
  		match 'receive_messages', via: :get, as: "/receive_messages"
      
  	end
    member do
      match 'reply_message', via: :post, as: "/reply_message"
    end
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount ActionCable.server => '/cable'
  root 'welcome#index'
end
