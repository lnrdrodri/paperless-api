Rails.application.routes.draw do
  namespace :v1, defaults: { format: 'json' } do
    namespace :users do
      resources :users
      
      post 'sessions', to: 'sessions#create'
      delete 'sessions', to: 'sessions#destroy'
    end
  end
end
