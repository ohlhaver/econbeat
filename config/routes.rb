Jurnalo::Application.routes.draw do
  



  resources :invitations

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  get "static_pages/home"

  get "static_pages/about"

  get "static_pages/privacy"

  get "static_pages/contact"

  get "static_pages/fb_new"

get 'contact', to: 'static_pages#contact', as: 'contact'
get 'privacy', to: 'static_pages#privacy', as: 'privacy'
#get '/signup', to: 'users#new', as: 'signup'
get 'login', to: 'sessions#new', as: 'login'
get 'logout', to: 'sessions#destroy', as: 'logout'
get 'edit', to: 'users#edit', as: 'edit'

match '/signup(/:invitation_token)' => 'users#new', as: 'signup'
#match '/signup' => 'users#new', as: 'signup'

match 'auth/:provider/callback', to: 'sessions#create'
match 'auth/failure', to: redirect('/')
match 'signout', to: 'sessions#destroy', as: 'signout'



resources :users do
    member do
      get :following, :followers, :authors
    end
end

resources :posts do
    member do
      get :star, :unstar, :share, :like, :preview
      post :add_comment, :add_message
    end
    collection { post :sort }
end

resources :subscriptions do
    member do
      get :star, :unstar, 
    end
end


resources :articles do
    member do
      get  :share, :like, :preview
      post :add_comment, :add_message
    end
    collection { post :sort }
end

resources :filters do
    member do
      post :new
    end
end


resources :static_pages do
    member do
      post :add_message
    end
end

resources :articles
resources :actions
resources :authors
resources :catchers

resources :filters, only: [:new, :create, :destroy]
resources :posts, only: [:new, :create, :destroy]
resources :sessions
resources :relationships, only: [:new, :create, :destroy]
resources :subscriptions, only: [:new, :create, :destroy]
resources :password_resets

resources :facebook_updates, :only=>[:create, :index]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'static_pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
