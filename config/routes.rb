Rails.application.routes.draw do
  post '/comment/:post_id' => 'comments#create'
  delete '/comment/:id/' => 'comments#destroy'
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'home#index'
  resources :posts do
    resources :likes, only: [:create, :destroy]
  end
  resources :users, only: [:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
