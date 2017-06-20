Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  get '/signup',   to: 'users#new'

  get '/login',    to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get 'p-:id-:name' => 'products#show', :id => /\d+/, as: :product, :format => :html

  resources :users

  namespace :admin do
    root to: 'home#index', as: 'root'

    resources :products do

    end
  end
end
