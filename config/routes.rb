Rails.application.routes.draw do
  root "pages#index"

  get 'welcome', :to => 'pages#welcome'
  post 'activities', :to => 'pages#activities'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
