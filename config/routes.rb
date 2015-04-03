Rails.application.routes.draw do

  post   'users/change_password', to: 'users#change_password', as: 'change_password'
  delete 'users/delete_pictures', to: 'users#delete_pictures', as: 'delete_pictures'
  get    'users/login', to: 'users#login', as: 'login_user'
  post   'users/login', to: 'users#login_user'
  root to: 'users#login'
  delete 'users/logout', to: 'users#logout', as: 'logout_user'
  
  post   'upload',  to: 'mosaics#upload', as: 'upload'
  delete 'mosaics', to: 'mosaics#delete'
  
  resources :users
  resources :mosaics


end
