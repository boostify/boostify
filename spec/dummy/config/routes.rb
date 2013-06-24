Rails.application.routes.draw do

  resources :donations, only: [:new, :create, :show]

  mount Boostify::Engine => '/boostify'
end
