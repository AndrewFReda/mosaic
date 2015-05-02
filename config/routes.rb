Rails.application.routes.draw do


  root to: 'application#index'

  # Naming the resource singularly enables you to leave off the :id
  resource :session, only: [:create, :destroy, :show]
  resources :users do
    resources :pictures
  end

=begin

  delete 'users/delete_pictures', to: 'users#delete_pictures', as: 'delete_pictures'
  post   'upload',       to: 'users#upload_pictures', as: 'upload'
  
  delete 'mosaics', to: 'pictures#delete_mosaic'
  post   'mosaics', to: 'pictures#create_mosaic'
  
  resources :users
  resources :pictures

=end

end
