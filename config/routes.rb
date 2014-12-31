Rails.application.routes.draw do
  root to: 'static_page#home'
  resources :teams

  devise_for :users, path_names:  {sign_in: "login", sign_out: "logout"},
                     controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  namespace :api do
    namespace :v1 do
      get '/users/search', to: 'users#search', defaults: { format: :json }
    end
  end
end
