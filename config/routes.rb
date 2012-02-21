Hackful::Application.routes.draw do
	
  # /api/<request>
  scope 'api' do

    # /api/v1/<request>
    scope 'v1' do
      devise_for :users, :controllers => {:sessions => 'api/v1/sessions'}, :path => "sessions", :only => :sessions

      match 'signup' => 'api/v1/users#signup', via: :post
      
      match 'users/:name' => 'api/v1/users#show', via: :get
      match 'users/:name' => 'api/v1/users#update', via: :put
      
      match 'posts/frontpage' => 'api/v1/posts#frontpage', via: :get
      match 'posts/frontpage/page/:page' => 'api/v1/posts#frontpage', via: :get
      
      match 'posts/new' => 'api/v1/posts#new', via: :get
      match 'posts/new/page/:page' => 'api/v1/posts#new', via: :get
      
      match 'posts/ask' => 'api/v1/posts#ask', via: :get
      match 'posts/ask/page/:page' => 'api/v1/posts#ask', via: :get

      match 'posts' => 'api/v1/posts#create', via: :post
      match 'posts/:id' => 'api/v1/posts#show', via: :get
      match 'posts/:id/comments' => 'api/v1/posts#show_comments', via: :get
      match 'posts/:id/vote' => 'api/v1/posts#vote', via: :put

      # TODO: 404 error
      match '*a' => 'api/v1/base_api#render_404'
    end

    # TODO: 404 error
    match '*a' => 'api/v1/base_api#render_404'
  end

  match "/about" => "content#about"
    
  match "/user/:name" => "users#show", :as => 'user'
	
  #Voting routes
  match ":controller/:id/vote_up" => ":controller#vote_up"
  match ":controller/:id/vote_down" => ":controller#vote_down"
  
  match "/frontpage" => "content#frontpage"
  match "/notifications" => "content#notifications"

  match "/new" => "content#new"
  match "/ask" => "content#ask"

  resources :comments

  resources :posts

  devise_for :users

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
  root :to => 'content#frontpage'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
