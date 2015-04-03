Rails.application.routes.draw do

  root to: 'users#login'

  post   'users/change_password', to: 'users#change_password', as: 'change_password'
  delete 'users/delete_pictures', to: 'users#delete_pictures', as: 'delete_pictures'
  get    'users/login', to: 'users#new_login', as: 'login_user'
  post   'users/login', to: 'users#login'
  delete 'users/logout', to: 'users#logout', as: 'logout_user'
  post   'upload', to: 'users#upload_pictures', as: 'upload'
  
  delete 'mosaics', to: 'pictures#delete_mosaic'
  post   'mosaics', to: 'pictures#create_mosaic'
  
  resources :users
  resources :pictures

end
