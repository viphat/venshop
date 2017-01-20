Rails.application.routes.draw do

  root to: 'items#index'
  
  devise_for :users, skip: [:registrations, :sessions, :passwords]

  as :user do
    get 'users/register' => 'users/registrations#new', as: :new_user_registration
    post 'users/register' => 'users/registrations#create', as: :user_registration
    get 'users/login' => 'users/sessions#new', as: :new_user_session
    post 'users/login' => 'users/sessions#create', as: :user_session
    delete 'users/logout'=> 'users/sessions#destroy', as: :destroy_user_session
    get 'users/update_profile' => 'users/update_profile#new', as: :new_user_update_profile
    post 'users/update_profile' => 'users/update_profile#create', as: :user_update_profile
  end

  resources :items, only: [:index, :show]
  resources :categories, only: [:show]

end
