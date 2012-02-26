require 'test_helper'

class Api::V1::CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  fixtures :all

  def setup
    @comment = comments(:first)
    @post = posts(:first)
    @user = users(:david)
    @user.reset_authentication_token!
    @comment.commentable_id = @post.id
    @comment.commentable_type = "Post"
    @comment.save
  end

  def teardown
    @comemnt = nil
    @post = nil
    @user = nil
  end

  test "get a comment successfully" do
    get 'show', :format => :json, :id => @comment.id
    assert_response :success
  end

  test "show a comment" do
    get 'show', :format => :json, :id => @comment.id
    comment_json = JSON.parse(response.body)

    assert_equal @comment.id, comment_json["id"]
    assert_equal @comment.text, comment_json["text"]
    assert_equal @comment.up_votes, comment_json["up_votes"]
    assert_equal @comment.created_at, comment_json["created_at"].to_time
    #assert @comment.updated_at.to_datetime == comment_json["updated_at"].to_datetime
    assert_response :success
  end

  test "show comment for post" do
    create_comments(30)
    @comment.destroy

    get 'show_post_comments', :format => :json, :id => @post.id
    comment_json = JSON.parse(response.body)

    assert_equal 30, comment_json.length
    assert_response :success
  end

  test "show comment for user" do
    create_comments(30)

    get 'show_user_comments', :format => :json, :name => @user.name
    comment_json = JSON.parse(response.body)

    assert_equal 30, comment_json.length
    assert_response :success
  end

  test "vote a comment" do
    put "up_vote", :format => :json, :id => @comment.id, :auth_token => @user.authentication_token
    
    assert_response :success
    assert_equal 1, Comment.find(@comment.id).up_votes
  end

  test "down vote a comment" do
    assert_equal 0, @comment.up_votes
    vote_comment(@user, @comment)
    assert_equal 1, @comment.up_votes

    put "down_vote", :format => :json, :id => @comment.id, :auth_token => @user.authentication_token

    assert_response :success
    assert_equal 0, Comment.find(@comment.id).up_votes
  end

  test "create a comment with json format" do
    new_comment = {
      :text => "New awesome comment", 
      :commentable_id => @post.id,
      :commentable_type => "Post"
    }
    post("create", :format => :json, :auth_token => @user.authentication_token, :comment => new_comment)
    
    created_comment = Comment.find_by_text("New awesome comment")
    
    assert !created_comment.nil?
    assert_equal new_comment[:text], created_comment.text
    assert_equal @user.id, created_comment.user.id
    assert_equal 1, created_comment.up_votes
    assert_response :success
  end

  test "create a comment without json format" do
    new_comment = {
      :text => "New awesome comment", 
      :commentable_id => @post.id,
      :commentable_type => "Post"
    }
    post("create", :auth_token => @user.authentication_token, :comment => new_comment)
    
    created_comment = Comment.find_by_text("New awesome comment")
    
    assert !created_comment.nil?
    assert_equal new_comment[:text], created_comment.text
    assert_equal @user.id, created_comment.user.id
    assert_equal 1, created_comment.up_votes
    assert_response :success
  end

  test "update a comment with json format" do
    put "update", 
      :format => :json, 
      :id => @comment.id, 
      :auth_token => @user.authentication_token, 
      :comment => {:text => "Changed comment text"}
    
    updated_comment = Comment.find(@comment.id)

    assert !updated_comment.nil?
    assert_equal "Changed comment text", updated_comment.text
    assert_equal @user.id, updated_comment.user.id
    assert_response :success
  end

  test "update a comment without json format" do
    put "update", 
      :id => @comment.id, 
      :auth_token => @user.authentication_token, 
      :comment => {:text => "Changed comment text"}
    
    updated_comment = Comment.find(@comment.id)

    assert !updated_comment.nil?
    assert_equal "Changed comment text", updated_comment.text
    assert_equal @user.id, updated_comment.user.id
    assert_response :success
  end

  test "destroy a comment" do
    delete "destroy", 
      :format => :json, 
      :id => @comment.id, 
      :auth_token => @user.authentication_token

    assert_raise ActiveRecord::RecordNotFound do 
      deleted_comment = Comment.find(@comment.id)
    end 
    assert_response :success
  end

  private
  def create_comments(num)
    num.times do |i|
      comment = Comment.new({:text => "Post Text #{i}"})
      comment.user = @user
      comment.commentable_id = @post.id
      comment.commentable_type = "Post"
      comment.save
    end
  end

  def vote_comment(user, comment)
    user.up_vote(comment)
  end
end