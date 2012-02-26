require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
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

  
end