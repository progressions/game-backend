# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :rooms, only: [:index, :show]
      resources :players, only: [:show, :create] do
        post 'move', on: :member
      end
      resources :themes, only: [:index]
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
    end
  end
end
