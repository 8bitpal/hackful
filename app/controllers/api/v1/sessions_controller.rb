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
  

  def create
    build_resource
    email = params["user"]["email"]
    password = params["user"]["password"]
    resource = User.find_for_database_authentication(:email => email)
    return invalid_login_attempt unless resource
    return invalid_login_attempt unless resource.valid_password?(password)
     
    sign_in("user", resource)
    #puts "signed_in?: #{signed_in?}"
    resource.reset_authentication_token!

    token_json = {
      :auth_token => resource.authentication_token, 
      :name => resource.name, 
      :email => resource.email
    }
    return render :json => success_message("Successfully logged in", token_json)
  end

  def destroy
  	current_user.authentication_token = nil
    current_user.save
    render :json => success_message("Successfully logged out")
  end

  protected
  def invalid_login_attempt
    warden.custom_failure!
    render :json=> failure_message("Email or password incorrect"), :status=>401
  end
end