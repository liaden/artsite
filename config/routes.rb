ArchaicSmiles::Application.routes.draw do
    resources :artworks
    resources :tags
    resources :lessons, :path => 'classes/'
    resources :shows, :path => 'shows/'
    resources :medium
    resources :users
    resources :user_sessions
    resources :commissions

    match '/news' => 'news#index', :as => :news
    match '/schedule' => 'schedule#index', :as => :schedule
    
    match '/index' => 'main#index', :as => :home

    match '/prices/edit' => 'default_price#edit', :as => :price_edit
    match '/prices/update' => 'default_price#update', :as => :price_update

    match '/cart/checkout' => 'cart#verify_payment', :via => :post, :as => :verify_payment
    match '/cart/checkout' => 'cart#checkout', :via => :get, :as => :checkout
    match '/cart/purchase' => 'cart#purchase', :as => :purchase
    match '/cart/remove/:transaction_type/:id' => 'cart#remove'
    match '/cart' => 'cart#index', :as => :cart

    match '/purchase_history' => 'users#history', :as => :purchase_history

    match 'login' => 'user_sessions#new', :as => :login
    match 'logout' => 'user_sessions#destroy', :as => :logout

    root :to => 'main#index'
end
