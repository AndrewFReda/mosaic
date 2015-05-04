Rails.application.routes.draw do

  root to: 'application#index'

  # Naming the resource singularly enables you to leave off the :id
  resource :session, only: [:create, :destroy, :show]
  resources :users do
    resources :pictures
  end


end
