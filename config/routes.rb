Rails.application.routes.draw do
  post '/comment/:post_id' => 'comments#create'
  patch '/comment/:id' => 'comments#update'
  delete '/comment/:id/' => 'comments#destroy'
  devise_for :users, controllers: {
              registrations: 'registrations',
              omniauth_callbacks: 'omniauth_callbacks'
              }
  root 'top#index'
  resources :drafts, param: :article_token, except: [:index]
  resources :publics, param: :article_token, except: [:new, :edit, :update]
  get '/terms' => 'terms#index'
  resources :posts, param: :uuid do
    post '/like' => 'likes#create'
    delete '/unlike' => 'likes#destroy'
  end
  post 'posts/:uuid' => 'posts#update'
  resources :likes, only: [:index]
  resources :users, only: [:index, :show] do
    resources :follows, only: [:create, :destroy]
    get '/posts' => 'users#index'
    get '/follows' => 'follows#follow', as: "follows_list"
    get '/followers' => 'follows#follower', as: "followers_list"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
