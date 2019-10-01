Rails.application.routes.draw do
  root 'home#index'

  # Around User
  devise_for :users, controllers: {
              registrations: 'registrations',
              omniauth_callbacks: 'omniauth_callbacks'
              }
  resources :users, only: [:show] do
    resources :follows, only: [:create, :destroy]
  end
  get '/follows' => 'follows#follow', as: "follows_list"
  get '/followers' => 'follows#follower', as: "followers_list"

  # Around Dashboard
  get '/dashboard' => 'dashboard#index', as: 'dashboard'
  get '/dashboard/articles' => 'dashboard#article', as: 'dashboard_article'
  get '/dashboard/comments' => 'dashboard#comment', as: 'dashboard_comment'

  # Around Article
  resources :drafts, param: :article_token, except: [:index, :show, :destroy] do
    collection do
      post '/destroy' => 'drafts#destroy'
    end
  end
  resources :publics, param: :article_token, except: [:destroy] do
    collection do
      post '/destroy' => 'publics#destroy'
    end

    member do
      post '/like' => 'likes#create'
      delete '/unlike' => 'likes#destroy'
      post '/bookmark' => 'bookmarks#create'
      delete '/unbookmark' => 'bookmarks#destroy'
    end
  end
  resources :likes, only: [:index]
  get '/bookmarks' => 'bookmarks#index', as: "bookmarks"
  scope module: 'article' do
    resources :tags, param: :category, only: [:show]
    get '/history' => 'history#index', as: 'history'
  end

  # Around Comment
  post '/comment/:article_token' => 'comments#create'
  patch '/comment/:id' => 'comments#update'
  delete '/comment/:id/' => 'comments#destroy'

  # Terms
  get '/terms' => 'terms#index'
end
