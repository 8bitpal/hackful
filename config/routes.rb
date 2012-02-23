Hackful::Application.routes.draw do
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

  # /api/<request>
  scope 'api' do
    # /api/v1<request>
    scope 'v1' do
      devise_for :users, 
                 :controllers  => { :sessions => 'api/v1/sessions' }, 
                 :path_names   => { :sign_in  => 'login', 
                                    :sign_out => 'logout' }, 
                 :path         => "sessions", 
                 :only         => :sessions

      match 'signup'                      => 'api/v1/users#signup', via: :post
      
      match 'user/:name'                  => 'api/v1/users#show', via: :get
      match 'user/:name'                  => 'api/v1/users#update', via: :put
      
      match 'posts/frontpage'             => 'api/v1/posts#frontpage', via: :get
      match 'posts/frontpage/page/:page'  => 'api/v1/posts#frontpage', via: :get
      
      match 'posts/new'                   => 'api/v1/posts#new', via: :get
      match 'posts/new/page/:page'        => 'api/v1/posts#new', via: :get
      
      match 'posts/ask'                   => 'api/v1/posts#ask', via: :get
      match 'posts/ask/page/:page'        => 'api/v1/posts#ask', via: :get

      match 'post'                        => 'api/v1/posts#create', via: :post
      match 'post/:id'                    => 'api/v1/posts#show', :via => :get
      match 'post/:id/comments'           => 'api/v1/posts#show_comments', via: :get
      match 'post/:id/vote'               => 'api/v1/posts#vote', via: :put
    end

    # API call json 404 error
    match '*a' => 'api/application#not_found'
    root :to => 'api/application#not_found'
  end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'content#frontpage'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
