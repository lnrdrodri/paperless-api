Rails.application.routes.draw do
  namespace :v1, defaults: { format: 'json' } do
    namespace :users do
      resources :users
      
      post 'sessions', to: 'sessions#create'
      delete 'sessions', to: 'sessions#destroy'

      namespace :units do
        get '/', to: 'units#index'
        get '/:id', to: 'units#show'
        post '/', to: 'units#create'
        put '/:id', to: 'units#update'
        delete '/:id', to: 'units#destroy'
      end

      namespace :participants do
        get '/', to: 'participants#index'
        get '/:id', to: 'participants#show'
        post '/', to: 'participants#create'
        put '/:id', to: 'participants#update'
        delete '/:id', to: 'participants#destroy'
      end
    end
  end


  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
end
