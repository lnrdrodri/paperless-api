Rails.application.routes.draw do
  namespace :v1, defaults: { format: 'json' } do
    namespace :users do
      resources :users
      
      post 'sessions', to: 'sessions#create'
      get 'me', to: 'sessions#me'

      get '/roles', to: 'roles#index'
      get '/roles/:id', to: 'roles#show'
      post '/roles', to: 'roles#create'
      put '/roles/:id', to: 'roles#update'
      delete '/roles/:id', to: 'roles#destroy'

      get '/permissions', to: 'permissions#index'
      get '/permissions/:id', to: 'permissions#show'
      post '/permissions', to: 'permissions#create'
      put '/permissions/:id', to: 'permissions#update'
      delete '/permissions/:id', to: 'permissions#destroy'

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

      get '/addresses', to: 'addresses#index'
      get '/addresses/:id', to: 'addresses#show'
      post '/addresses', to: 'addresses#create'
      put '/addresses/:id', to: 'addresses#update'
      delete '/addresses/:id', to: 'addresses#destroy'

      get '/notes', to: 'notes#index'
      get '/notes/:id', to: 'notes#show'
      post '/notes', to: 'notes#create'
      put '/notes/:id', to: 'notes#update'
      delete '/notes/:id', to: 'notes#destroy'
      
      namespace :contacts do
        get '/', to: 'contacts#index'
        get '/:id', to: 'contacts#show'
        post '/', to: 'contacts#create'
        put '/:id', to: 'contacts#update'
        delete '/:id', to: 'contacts#destroy'
      end
    end
  end


  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
end
