Rails.application.routes.draw do

  get  'users/login', to: 'users#login',     as: 'login_user'
  post 'users/login', to: 'users#login_user'

  resources :mosaics
  resources :users
  root to: 'users#login'

end
