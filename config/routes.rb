Rails.application.routes.draw do
  root 'posts#new'
  post 'posts' => 'posts#create'
  delete 'posts/:id' => 'posts#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
