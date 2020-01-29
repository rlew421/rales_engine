Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get ':id/items', to: 'items#index'
        get 'most_revenue', to: 'search#top_x_merchants'
      end

      resources :merchants, only: [:index]
    end
  end
end
