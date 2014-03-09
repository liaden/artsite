ArchaicSmiles::Application.routes.draw do
    match '/artworks/filter/:category/' => 'artworks#filter_by_category', :as => :artworks_by_category

    resources :artworks do
        resources :prints do
            collection do
                get 'canvas'
                get 'photopaper'
                get 'original'
            end
        end
    end

    resources :tags do
        collection do
            post 'clear_orphans'
        end
    end

    resources :lessons, :path => 'classes/'
    resources :shows, :path => 'shows/'
    resources :medium
    resources :users
    resources :user_sessions
    resources :commissions
    resources :ideas
    resources :articles


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

    match 'inventory' => 'inventory#index', :as => :inventory
    match 'inventory/update/:id' => 'inventory#update', :as => :inventory_update
    match 'inventory/edit/:id' => 'inventory#edit', :as => :inventory_edit

    match 'main/subnav' => 'main#subnavbar', :as => :subnavbar

    root :to => 'main#index'
end
