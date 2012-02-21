class Api::V1::UsersController < Api::V1::BaseApiController
  before_filter :authenticate_user!, :except => [:login, :signup]

  # GET /api/v1/users/:name   
  def show
  	@user = User.find_by_name(params[:name].to_s)
    params[:page].nil? ? @page = 0 : @page = params[:page].to_i
    @posts = Post.find_by_sql ["SELECT * FROM posts WHERE user_id = #{@user.id} ORDER BY ((posts.up_votes - posts.down_votes) -1 )/POW((((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(posts.created_at)) / 3600 )+2), 1.5) DESC LIMIT ?, 20", (@page*20)]		
  	
  	# TODO: Email address only for registred users and loged in ?
    render :json => { :name => @user.name, :posts => @posts }
  end
  
  # PUT /api/v1/users/:name
  def update
  	# TODO:
  end
 
  # POST /api/v1/login
  def login
  	user = User.find_for_database_authentication(:email=>params[:user_login][:email])
    return invalid_login_attempt unless user
    
    if user.valid_password?(params[:user_login][:password])
      sign_in("user", user)
      render :json=> { :success=>true, :auth_token=>user.authentication_token, :login=>user.name, :email=>user.email }
      return
    end
    invalid_login_attempt
  end

  # PUT /api/v1/logout
  def logout
  	sign_out(resource_name)
  end
  
  # POST /api/v1/signup
  def signup
  	# TODO:
  end

  protected
  def ensure_params_exist
    return unless params[:user_login].blank?
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end

end
