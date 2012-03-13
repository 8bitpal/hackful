require "#{File.dirname(__FILE__)}/../basic_api"
class Api::V1::SessionsController < Devise::SessionsController
  include Api::BasicApi

  respond_to :json
  
  prepend_before_filter :require_no_authentication, :only => [:create]
  before_filter :set_format
  before_filter :check_login, only: :destroy
  before_filter :authenticate_user!
  
  rescue_from Exception do |exception| internal_server_error(exception) end
  rescue_from ActionController::UnknownAction, :with => :unknown_action
  rescue_from ActionController::RoutingError, :with => :route_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Api::BasicApi::NotLogedIn, with: :not_loged_in
  
  # POST /api/v1/sessions/login
  def create
    return invalid_login_attempt if params["user"].nil?
    build_resource
    email = params["user"]["email"]
    password = params["user"]["password"]
    resource = User.find_for_database_authentication(:email => email)
    return invalid_login_attempt unless resource
    return invalid_login_attempt unless resource.valid_password?(password)
     
    sign_in("user", resource)
    resource.ensure_authentication_token!

    user_token_json = {
      :auth_token => resource.authentication_token,
      :user => {
        :id => resource.id,
        :name => resource.name, 
        :email => resource.email,
      }
    }
    return render :json => success_message("Successfully logged in", user_token_json)
  end

  # DELETE /api/v1/sessions/logout
  def destroy
    current_user.authentication_token = nil
    current_user.reset_authentication_token!
    current_user.save
    token = current_user.authentication_token
    
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    
    render :json => success_message("Successfully logged out")
  end

  protected
  def invalid_login_attempt
    warden.custom_failure!
    render :json=> failure_message("Email or password incorrect"), :status=>401
  end
end