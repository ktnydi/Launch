Rails.application.routes.draw do
  post '/comment/:post_id' => 'comments#create'
  delete '/comment/:id/' => 'comments#destroy'
  devise_for :users, controllers: {
              registrations: 'registrations',
              omniauth_callbacks: 'omniauth_callbacks'
              }
  root 'top#index'
  get '/terms' => 'terms#index'
  resources :posts do
    resources :likes, only: [:create, :destroy]
  end
  resources :likes, only: [:index]
  resources :users, only: [:index, :show] do
    resources :follows, only: [:create, :destroy]
    get '/posts' => 'users#index'
    get '/follows' => 'follows#follow', as: "myfollows"
    get '/followers' => 'follows#follower', as: "myfollowers"
    get '/myposts' => 'posts#mypost'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
