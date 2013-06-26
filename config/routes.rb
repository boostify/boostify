Boostify::Engine.routes.draw do

  resources :charities, only: [:index, :show]

  resources :donations, only: [:create, :show]
end
