Rails.application.routes.draw do
  root to: 'static_page#home'

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    get 'signin',  :to => 'devise/sessions#new',     :as => :new_user_session
    get 'signout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
end
