Boostify::Engine.routes.draw do

  resources :charities, only: [:index, :show]
end
