Rails.application.routes.draw do
  get 'home/about' => "homes#about"
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  resources :books
  post "favorites/:user_id/:book_id" => "favorites#create", as: "favorites_create"
  delete "favorites/:user_id/:book_id" => "favorites#destroy", as: "favorites_destroy"
  post "book_comments/:user_id/:book_id" => "book_comments#create", as: "book_comments_create"
  delete "book_comments/:user_id/:book_id" => "book_comments#destroy", as: "book_comments_destroy"
  root to: "homes#top"
end
