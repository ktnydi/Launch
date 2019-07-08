Rails.application.routes.draw do
  post '/comment/:article_token' => 'comments#create'
  patch '/comment/:id' => 'comments#update'
  delete '/comment/:id/' => 'comments#destroy'
  devise_for :users, controllers: {
              registrations: 'registrations',
              omniauth_callbacks: 'omniauth_callbacks'
              }
  root 'users#index'
  resources :drafts, param: :article_token, except: [:index]
  resources :publics, param: :article_token, except: [:new, :edit, :update]
  get '/terms' => 'terms#index'
  resources :publics, param: :article_token do
    post '/like' => 'likes#create'
    delete '/unlike' => 'likes#destroy'
  end
  resources :likes, only: [:index]
  resources :users, only: [:index] do
    resources :follows, only: [:create, :destroy]
    get '/follows' => 'follows#follow', as: "follows_list"
    get '/followers' => 'follows#follower', as: "followers_list"
  end

  get '/history' => 'publics#history', as: "history"

  # get '/dashboard' => 'users#show', as: 'dashboard'
  get '/dashboard' => 'dashboard#index', as: 'dashboard'
  get '/dashboard/articles' => 'dashboard#article', as: 'dashboard_article'
  get '/dashboard/comments' => 'dashboard#comment', as: 'dashboard_comment'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
