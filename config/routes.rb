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
      get "/images" => "products#images", as: :images
      post "/images-upload-batch" => "products#upload", as: :upload

      member do
        post "/images/:image_id" => "products#images_delete", as: :delete_images
        get "/variants" => "products#variants", as: :variants
        get "/variants/new" => "products#new_variant", as: :new_variant

        post "/variant" => "products#create_variant", as: :create_variant

        get "/variant/:variant_id" => "products#edit_variant", as: :edit_variant

        patch "/variant/:variant_id" => "products#update_variant", as: :update_variant

      end
    end
  end
end
