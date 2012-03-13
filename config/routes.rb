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
      
      match 'user/notifications'          => 'api/v1/users#notifications', via: :get
      match 'user/:id'                    => 'api/v1/users#show', via: :get
      match 'user'                        => 'api/v1/users#update', via: :put
      
      match 'posts/frontpage(/:page)'     => 'api/v1/posts#frontpage', via: :get
      match 'posts/new(/:page)'           => 'api/v1/posts#new', via: :get
      match 'posts/ask(/:page)'           => 'api/v1/posts#ask', via: :get

      match 'post'                        => 'api/v1/posts#create', via: :post
      match 'post/:id'                    => 'api/v1/posts#update', via: :put
      match 'post/:id'                    => 'api/v1/posts#destroy', via: :delete
      match 'post/:id'                    => 'api/v1/posts#show', :via => :get
      match 'posts/user/:id(/:page)'              => 'api/v1/posts#show_user_posts', :via => :get
      match 'post/:id/upvote'             => 'api/v1/posts#up_vote', via: :put
      match 'post/:id/downvote'           => 'api/v1/posts#down_vote', via: :put

      match 'comments/user/:id'           => 'api/v1/comments#show_user_comments', via: :get
      match 'comments/post/:id'           => 'api/v1/comments#show_post_comments', via: :get
      match 'comment/:id'                 => 'api/v1/comments#show', via: :get
      match 'comment/:id/upvote'          => 'api/v1/comments#up_vote', via: :put
      match 'comment/:id/downvote'        => 'api/v1/comments#down_vote', via: :put
      match 'comment'                     => 'api/v1/comments#create', via: :post
      match 'comment/:id'                 => 'api/v1/comments#update', via: :put
      match 'comment/:id'                 => 'api/v1/comments#destroy', via: :delete
    end

    # API call json 404 error
    match '*a' => 'api/application#not_found'
    root :to => 'api/application#not_found'
  end

  devise_for :users
  

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'content#frontpage'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
