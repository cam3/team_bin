Rails.application.routes.draw do
  root to: 'static_page#home'

  devise_for :users, path_names:  {sign_in: "login", sign_out: "logout"},
                     controllers: { omniauth_callbacks: 'omniauth_callbacks' }
end
