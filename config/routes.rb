ArchaicSmiles::Application.routes.draw do

  root :to => 'main#index'
  ActiveAdmin.routes(self)

  get '/artworks/filter/:category/' => 'artworks#filter_by_category', :as => :artworks_by_category

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
  resources :pages
  resources :supplies

  resources :status, only: [:index]


  get '/news' => 'news#index', :as => :news
  get '/schedule' => 'schedule#index', :as => :schedule
  
  get '/index' => 'main#index', :as => :home

  get '/prices/edit' => 'default_price#edit', :as => :price_edit
  get '/prices/update' => 'default_price#update', :as => :price_update

  post '/cart/checkout' => 'cart#verify_payment', :as => :verify_payment
  get  '/cart/checkout' => 'cart#checkout', :as => :checkout
  get  '/cart/purchase' => 'cart#purchase', :as => :purchase
  get  '/cart/remove/:transaction_type/:id' => 'cart#remove'
  get  '/cart' => 'cart#index', :as => :cart

  get '/purchase_history' => 'users#history', :as => :purchase_history

  get 'login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout

  get 'inventory' => 'inventory#index', :as => :inventory
  get 'inventory/update/:id' => 'inventory#update', :as => :inventory_update
  get 'inventory/edit/:id' => 'inventory#edit', :as => :inventory_edit

  get 'main/admin_controls' => 'main#admin_controls', :as => :admin_controls
  post 'markdown/preview' => 'main#preview_markdown', :as  => :preview_markdown
end
