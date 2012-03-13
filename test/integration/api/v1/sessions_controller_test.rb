require 'test_helper'
require 'rest_client'

class Api::V1::PostsControllerTest < ActionDispatch::IntegrationTest
  fixtures :all
  
  PASSWORD = "test123"

  def setup
    @comment = comments(:first)
    @post = posts(:first)
    @user = User.new({
      :name => "David Johnson",
      :email => "david.johnson@example.com",
      :password => PASSWORD,
      :password_confirmation => PASSWORD
    })
    @user.reset_authentication_token!
    @user.save
  end

  def teardown
    @comemnt = nil
    @post = nil
    @user = nil
  end

  test "login and recieve auth_token" do
    post "/api/v1/sessions/login", 
      :format => :json, 
      :user => {:email => @user.email, :password => "test123"}
    
    session_json = JSON.parse(response.body)

    @user = User.find_by_email(@user.email)
    assert_equal @user.id, session_json["user"]["id"]
    assert_equal @user.email, session_json["user"]["email"]
    assert_equal @user.name, session_json["user"]["name"]
    assert_equal @user.authentication_token, session_json["auth_token"]
    assert_response :success
  end

  test "try to login and fail" do
    post "/api/v1/sessions/login",
      :format => :json, 
      :user => {:email => @user.email, :password => "WRONG PASSWORD"}
    session_json = JSON.parse(response.body)

    assert_equal false, session_json["success"]
    assert_response 401
  end

  test "logout with existing token" do
    post "/api/v1/sessions/login",
      :format => :json, 
      :user => {:email => @user.email, :password => "test123"}
    
    session_json = JSON.parse(response.body)
    auth_token = session_json["auth_token"]
    assert !auth_token.nil?

    delete "/api/v1/sessions/logout", :format => :json, :auth_token => auth_token
    destroy_session_json = JSON.parse(response.body)

    assert destroy_session_json["success"]
    assert_response :success
  end

  test "try to logout with expired token" do
    auth_token = "51nLGdjsBcB2PUrudx2s"
    
    delete "/api/v1/sessions/logout", :format => :json, :auth_token => auth_token
    destroy_session_json = JSON.parse(response.body)
    
    assert !destroy_session_json["success"]
    assert_response 401
  end

  test "try to logout with logged out token" do
    # login
    post "/api/v1/sessions/login",
      :format => :json, 
      :user => {:email => @user.email, :password => "test123"}
    
    session_json = JSON.parse(response.body)
    auth_token = session_json["auth_token"]
    assert !auth_token.nil?
    
    # logout
    delete "/api/v1/sessions/logout", :format => :json#, :auth_token => auth_token
    first_logout_json = JSON.parse(response.body)
    
    assert first_logout_json["success"]
    assert_response :success

    # logout a second time to check if first time worked
    delete "/api/v1/sessions/logout", :format => :json, :auth_token => auth_token
    second_logout_json = JSON.parse(response.body)
    
    assert !second_logout_json["success"]
    assert_response 401
  end
end