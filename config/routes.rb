Rails.application.routes.draw do
  root to: 'items#index'

  devise_for :users, skip: [:registrations, :sessions, :passwords], :controllers => {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  as :user do
    get 'users/register' => 'users/registrations#new', as: :new_user_registration
    post 'users/register' => 'users/registrations#create', as: :user_registration
    get 'users/login' => 'users/sessions#new', as: :new_user_session
    post 'users/login' => 'users/sessions#create', as: :user_session
    delete 'users/logout'=> 'users/sessions#destroy', as: :destroy_user_session
    get 'users/:id/profile' => 'users/profile#edit', as: :edit_user_profile
    put 'users/:id/profile' => 'users/profile#update', as: :update_user_profile
  end

  resources :items, only: [:index, :show, :new, :edit, :create, :update]
  resources :categories, only: [:show]

  get '/cart', to: 'cart#show', as: :show_cart
  put '/cart', to: 'cart#update', as: :update_cart

  resources :orders, only: [:index, :edit, :update]
  resources :order_items, only: [:create, :update, :destroy]

end
