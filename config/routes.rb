Rails.application.routes.draw do

  post   'users/change_password', to: 'users#change_password', as: 'change_password'
  get  'users/login', to: 'users#login', as: 'login_user'
  post 'users/login', to: 'users#login_user'
  root to: 'users#login'
  
  post   'upload',  to: 'mosaics#upload', as: 'upload'
  
  resources :users
  resources :mosaics


end
