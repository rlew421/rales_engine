Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :customers do
        get ':id/invoices', to: 'invoices#index'
        get ':id/transactions', to: 'transactions#index'
      end

      namespace :merchants do
        get ':id/items', to: 'items#index'
        get ':id/invoices', to: 'invoices#index'
      end

      namespace :items do
        get ':id/invoice_items', to: 'invoice_items#index'
        get ':id/merchant', to: 'merchant#show'
      end

      namespace :invoices do
        get ':id/customer', to: 'customer#show'
        get ':id/merchant', to: 'merchant#show'
        get ':id/invoice_items', to: 'invoice_items#index'
        get ':id/items', to: 'items#index'
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
