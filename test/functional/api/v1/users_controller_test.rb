require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
  def setup
    @post = posts(:first)
    @user = users(:david)
    @john = users(:john)
    @user.reset_authentication_token!
    @post.user = @user
    @post.save
  end

  def teardown
    @user = nil
  end

  test "show user" do
    get "show", :format => :json, :id => @user.id
    user_json = JSON.parse(response.body)

    assert_equal @user.name, user_json["name"]
    assert_equal @user.id, user_json["id"]
    assert_response :success
  end

  test "show user when logged in" do
    get "show", 
      :format => :json, 
      :id => @user.id, 
      :auth_token => @user.authentication_token

    user_json = JSON.parse(response.body)

    assert_equal @user.name, user_json["name"]
    assert_equal @user.id, user_json["id"]
    assert_equal @user.email, user_json["email"]
    assert_response :success
  end

  test "update user" do
    put "update", 
      :format => :json,
      :auth_token => @user.authentication_token, 
      :user => {:name => "NewName"}

    updated_user = User.find(@user.id)
    assert !updated_user.nil?
    assert_equal @user.email, updated_user.email
    assert_equal "NewName", updated_user.name
    assert_equal @user.id, updated_user.id
    assert_response :success
  end

  test "try to update user with invalid data" do
    put "update", 
      :format => :json,
      :auth_token => @user.authentication_token, 
      :user => {:name => "New Name"}

    updated_user = User.find(@user.id)
    assert !updated_user.nil?
    assert_equal @user.email, updated_user.email
    assert_equal @user.name, updated_user.name
    assert_equal @user.id, updated_user.id
    assert_response 422
  end

  test "try to update user without beign logged in" do
    put "update", 
      :format => :json,
      :user => {:name => "New Name"}

    updated_user = User.find(@user.id)
    assert !updated_user.nil?
    assert_equal @user.email, updated_user.email
    assert_equal @user.name, updated_user.name
    assert_equal @user.id, updated_user.id
    assert_response 401
  end

  test "signup user" do
    new_user = {
      :name => "AlexBro",
      :email => "alex.bro@example.com",
      :password => "test123",
      :password_confirmation => "test123" 
    }
    post "signup", 
      :format => :json, 
      :user => new_user 

    response_json = JSON.parse(response.body)
    new_user = User.find_by_email("alex.bro@example.com")
    assert !new_user.nil?
    assert_equal new_user.email, new_user[:email]
    assert_equal new_user.name, new_user[:name]
    assert_equal new_user.authentication_token, response_json["user"]["auth_token"]
    assert_response 201
  end

  test "try to signup user with invalid data" do
    new_user = {
      :name => "Alex Bro",
      :email => "alex.bro@example.com",
      :password => "test123",
      :password_confirmation => "test123" 
    }
    post "signup", 
      :format => :json, 
      :user => new_user 

    response_json = JSON.parse(response.body)
    assert_response 422
  end

  test "get notifications of user" do
    comment = create_comment(@user, @post)
    create_comment(@john, comment)

    get "notifications", :format => :json, :auth_token => @user.authentication_token
    notification_json = JSON.parse(response.body)
    
    assert_equal 2, notification_json["new_notifications"].length
    assert_equal 0, notification_json["old_notifications"].length
    assert_response :success
  end

  test "get old notifications of user" do
    comment = create_comment(@user, @post)
    create_comment(@john, comment)

    get "notifications", :format => :json, :auth_token => @user.authentication_token
    get "notifications", :format => :json, :auth_token => @user.authentication_token
    notification_json = JSON.parse(response.body)

    assert_equal 0, notification_json["new_notifications"].length
    assert_equal 2, notification_json["old_notifications"].length
    assert_response :success
  end

  test "try to get notifications of user without beign logged in" do
    get "notifications", :format => :json

    assert_response 401
  end

  private
  def create_comment(user, commentable)
    comment = Comment.new
    comment.text = "This is a sample Comment"
    comment.user = user
    comment.commentable_id = commentable.id
    comment.commentable_type = commentable.class.name.demodulize
    comment.save

    return comment
  end
end