ParkifyRails::Application.routes.draw do
  resources :price_intervals

  resources :agreements

  resources :quick_properties

  root :to => "home#index"
  
  match "/cindex" => "home#core_index"
  match "/faq" => "home#faq"
  match "/about" => "home#about"
  match "/contact" => "home#contact"
  match "/tos" => "home#tos"
  match "/privacy" => "home#privacy"
  
  #fix for first iphone release
  match "/users/sign_in" => redirect("http://parkify-rails.herokuapp.com/my/users/sign_in")
  
  devise_for :users, :path_prefix => 'my'
  
  resources :users
  
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  
  get "parking_spots/create"

  get "parking_spots/new"

  post "parking_spots/create"
  
  resource :profile, :controller => "users"

  #resources :users
  
  resources :price_plans

  resources :images

  resources :cars

  resources :stripe_customer_ids

  resources :payment_infos

  resources :locations

  resources :capacity_intervals

  resources :capacity_lists

  resources :acceptances

  

  resources :resources do
    resources :offers
  end

  
  namespace :api do
      namespace :v1 do
        devise_for :users
        resources :resources, :controller => "parking_spots", :only => [:index, :show]
        resources :acceptances, :controller => "app_transactions", :only => [:create] do
          post 'preview', :on => :collection
        end
        resource :account, :controller => "account" do
          post 'add_card', :on => :collection
          post 'add_car', :on => :collection
          post 'activate_card', :on => :collection
          post 'update_cars', :on => :collection
        end
      end
  end

  
  # in case a user tries to go to somewhere they shouldn't
  #match '*' => redirect('http://www.parkify.me')

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
