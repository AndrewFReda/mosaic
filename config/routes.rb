Rails.application.routes.draw do
  
  root 'mosaics#new'
  resources :mosaics

  get 'mosaics/base', to: 'mosaics#base'
  get 'mosaics/composition', to: 'mosaics#composition'
  get 'mosaics/dimensions', to: 'mosaics#dimensions'

end
