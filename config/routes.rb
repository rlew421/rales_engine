Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get ':id/items', to: 'items#index'
        get ':id/invoices', to: 'invoices#index'
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
