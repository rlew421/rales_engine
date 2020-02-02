Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :customers do
        get ':id/invoices', to: 'invoices#index'
        get ':id/transactions', to: 'transactions#index'
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
      end

      namespace :merchants do
        get ':id/items', to: 'items#index'
        get ':id/invoices', to: 'invoices#index'
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        get ':id/favorite_customer', to: 'statistics#favorite_customer'
      end

      namespace :items do
        get ':id/invoice_items', to: 'invoice_items#index'
        get ':id/merchant', to: 'merchant#show'
        get 'find', to: 'search#show'
      end

      namespace :invoices do
        get ':id/customer', to: 'customer#show'
        get ':id/merchant', to: 'merchant#show'
        get ':id/invoice_items', to: 'invoice_items#index'
        get ':id/items', to: 'items#index'
        get ':id/transactions', to: 'transactions#index'
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
      end

      namespace :invoice_items do
        get ':id/invoice', to: 'invoices#show'
        get ':id/item', to: 'items#show'
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
      end

      namespace :transactions do
        get ':id/invoice', to: 'invoices#show'
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
      end

      resources :customers, only: [:index, :show]

      resources :merchants, only: [:index, :show]

      resources :items, only: [:index, :show]

      resources :invoices, only: [:index, :show]

      resources :invoice_items, only:[:index, :show]

      resources :transactions, only: [:index, :show]
    end
  end
end
