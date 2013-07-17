Boostify::Engine.routes.draw do

  resources :charities, only: [:index, :show]

  resources :donations, only: [:new, :create, :show, :update]
end
