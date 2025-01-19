Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  
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

      namespace :contacts do
        get '/', to: 'contacts#index'
        get '/:id', to: 'contacts#show'
        post '/', to: 'contacts#create'
        put '/:id', to: 'contacts#update'
        delete '/:id', to: 'contacts#destroy'
      end
    end
  end
end
