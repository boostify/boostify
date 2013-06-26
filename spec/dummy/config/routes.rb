Rails.application.routes.draw do

  resources :transactions, only: [:index, :show]

  mount Boostify::Engine => '/boostify'
end
