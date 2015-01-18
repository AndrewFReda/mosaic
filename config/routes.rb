Rails.application.routes.draw do

 
  get  'upload',      to: 'mosaics#upload'
  post 'upload_comp', to: 'mosaics#upload_comp', as: 'upload_comp'
  post 'upload_base', to: 'mosaics#upload_base', as: 'upload_base'

  get  'users/login', to: 'users#login',     as: 'login_user'
  post 'users/login', to: 'users#login_user'

  resources :mosaics
  resources :users
  root to: 'users#login'

end
