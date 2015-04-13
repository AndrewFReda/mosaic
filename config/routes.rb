Rails.application.routes.draw do


  root to: 'application#index'

  # Naming the resource singularly enables you to leave off the :id
  resource :session, only: [:create, :destroy, :show]
  resources :users

  get 'users/:id/pictures/mosaics', to: 'users#mosaics'

=begin

  post   'users/change_password', to: 'users#change_password', as: 'change_password'
  delete 'users/delete_pictures', to: 'users#delete_pictures', as: 'delete_pictures'
  post   'users/login',  to: 'users#login',           as: 'login_user'
  delete 'users/logout', to: 'users#logout',          as: 'logout_user'
  post   'upload',       to: 'users#upload_pictures', as: 'upload'
  
  delete 'mosaics', to: 'pictures#delete_mosaic'
  post   'mosaics', to: 'pictures#create_mosaic'
  
  resources :users
  resources :pictures

=end

end
