class Api::V1::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [:create]
  before_filter :authenticate_user!, :ensure_params_exist, :set_content_type
  after_filter :set_content_type
  
  def create
    build_resource
    resource = User.find_for_database_authentication(:email=>params[:user][:email])
    return invalid_login_attempt unless resource
	
    if resource.valid_password?(params[:user][:password])
      #sign_in("user", resource)
      puts "signed_in?: #{signed_in?}"
      resource.reset_authentication_token!
      render :json=> {:success=>true, :auth_token=>resource.authentication_token, :name=>resource.name, :email=>resource.email}
      return
    end
    invalid_login_attempt
  end

  def destroy
  	puts "user_signed_in?: #{user_signed_in?}"
  	if user_signed_in? then
		puts current_user.email
    	current_user.authentication_token = nil
    	current_user.save
    	render :json => {:success => true, :message => "Successfully logged out"}
	else
    	render :json => {:success => false, :message => "No logged in user found"}, :status => 401
    end
  end

  protected
  def ensure_params_exist
    return unless params[:user].blank? and params[:action].eql? "create"
    render :json=>{:success=>false, :message=>"Missing user parameter"}, :status=>422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end