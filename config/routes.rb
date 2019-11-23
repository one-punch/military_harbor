require 'sidekiq/web'
require 'admin_constraint'
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  get '/signup',   to: 'users#new'

  get '/login',    to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get 'p-:id-:name' => 'products#show', :id => /\d+/, as: :product, :format => :html

  get 'view-:id-teacher-:name' => 'products#teacher', :id => /\d+/, as: :teacher_viewer, :format => :html
  get 'view-:id-student-:name' => 'products#student', :id => /\d+/, as: :student_viewer, :format => :html

  get 'exam-:id-teacher-:name' => 'papers#teacher_exam', :id => /\d+/, as: :teacher_exam, :format => :html

  get 'exam-:id-student-:name' => 'papers#student_exam', :id => /\d+/, as: :student_exam, :format => :html

  get "/c/:category_id/filter" => 'products#filters', :category_id => /\d+/, as: :product_filters

  get 'paper-:token' => 'papers#show', as: :paper

  resources :users
  resources :user_favorites

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  get '/profile',  to: 'users#profile'
  get '/settings', to: 'users#settings'

  resources :cart_items, only: [:create, :update, :destroy] do
    collection do
      post 'toggle', to: 'cart_items#toggle'
    end

    member do
      get 'info', to: 'cart_items#info'
    end
  end

  resources :orders

  resources :products, only: [:index]

  get '/cart', to: 'cart_items#index'
  get '/checkout', to: 'orders#new'

  get '/about/:name', to: 'home#about', as: :about

  namespace :admin do
    mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new

    root to: 'home#index', as: 'root'

    resources :products do
      get "/images" => "products#images", as: :images
      post "/images-upload-batch" => "products#upload", as: :upload

      collection do
        post :import
      end

      member do
        post "/images/:image_id" => "products#images_delete", as: :delete_images
        get "/variants" => "products#variants", as: :variants
        get "/variants/new" => "products#new_variant", as: :new_variant

        post "/variant" => "products#create_variant", as: :create_variant

        get "/variant/:variant_id" => "products#edit_variant", as: :edit_variant

        patch "/variant/:variant_id" => "products#update_variant", as: :update_variant

        delete "/variant/:variant_id" => "products#delete_variant", as: :delete_variant

        delete "/property/:property_id" => "products#delete_property", as: :delete_property

      end
    end

    resources :ajax_select do
      collection do
        get :category
        get :product
        get :user
      end
    end

    resources :users
    resources :orders
    resources :shippers
    resources :virtual_products do
      member do
        get "/actual_products" => "virtual_products#actual_products", as: :actual_products
        post :add
        get :products
      end
    end
    resources :categories do
      collection { put :sort }
    end
    resources :product_details
  end

  namespace :api do
    resources :exam_papers
    resources :class_papers
  end
end
