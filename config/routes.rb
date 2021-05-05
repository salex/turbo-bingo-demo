Rails.application.routes.draw do
  resources :patterns
  resources :games

  resource :bingo, only: [:show, :edit, :update]
  
  get 'caller', to: 'bingos#edit'
  get 'viewer', to: 'bingos#show'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
