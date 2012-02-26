require 'test_helper'

class Api::V1::SessionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @comment = comments(:first)
    @post = posts(:first)
    @user = users(:david)
    @user.reset_authentication_token!
  end

  def teardown
    @comemnt = nil
    @post = nil
    @user = nil
  end

  test "login and recieve auth_token" do
  end

  test "try to login and fail" do
  end

  test "logout with existing token" do
  end

  test "try to logout with expired token" do
  end
  
end
