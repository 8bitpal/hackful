require 'test_helper'

class Api::V1::PostsControllerTest < ActionController::TestCase
  def setup
    @post = posts(:first)
    @user = users(:david)
    @user.reset_authentication_token!
  end

  def teardown
    @post = nil
    @user = nil
  end

  test "should be successful" do
    get 'show', :format => :json, :id => @post.id
    assert_response :success
  end

  test "show a post" do
    get 'show', :format => :json, :id => @post.id
    post_json = JSON.parse(response.body)

    assert_equal @post.id, post_json["id"]
    assert_equal @post.title, post_json["title"]
    assert_equal @post.link, post_json["link"]
    assert_equal @post.text, post_json["text"]
    assert_equal @post.up_votes, post_json["up_votes"]
    assert @post.created_at == post_json["created_at"].to_time
    assert @post.updated_at == post_json["updated_at"].to_time
  end

  test "vote a post" do
    put "up_vote", :format => :json, :id => @post.id, :auth_token => @user.authentication_token
    
    assert_response :success
    assert_equal 1, Post.find(@post.id).up_votes
  end

  test "try to vote a post without beign logged in" do
    put "up_vote", :format => :json, :id => @post.id
    
    assert_response 401
    assert_equal 0, Post.find(@post.id).up_votes
  end

  test "down vote a post" do
    assert_equal 0, @post.up_votes
    vote_post(@user, @post)
    assert_equal 1, @post.up_votes

    put "down_vote", :format => :json, :id => @post.id, :auth_token => @user.authentication_token

    assert_response :success
    assert_equal 0, Post.find(@post.id).up_votes
  end

  test "try to down vote a post without beign logged in" do
    assert_equal 0, @post.up_votes
    vote_post(@user, @post)
    assert_equal 1, @post.up_votes

    put "down_vote", :format => :json, :id => @post.id

    assert_response 401
    assert_equal 1, Post.find(@post.id).up_votes
  end

  test "create a post with json format" do
    new_post = {
      :link => "http://example.com/", 
      :title => "New Post", 
      :text => "New awesome post"
    }
    post("create", :format => :json, :auth_token => @user.authentication_token, :post => new_post)
    
    created_post = Post.find_by_link("http://example.com/")
    assert !created_post.nil?
    assert_equal new_post[:title], created_post.title
    assert_equal new_post[:link], created_post.link
    assert_equal new_post[:text], created_post.text
    assert_equal @user.id, created_post.user.id
    assert_equal 1, created_post.up_votes
    assert_response :success
  end

  test "create a post without json format" do
    new_post = {
      :link => "http://example.com/", 
      :title => "New Post", 
      :text => "New awesome post"
    }
    post("create", :auth_token => @user.authentication_token, :post => new_post)
    
    created_post = Post.find_by_link("http://example.com/")
    assert !created_post.nil?
    assert_equal new_post[:title], created_post.title
    assert_equal new_post[:link], created_post.link
    assert_equal new_post[:text], created_post.text
    assert_equal @user.id, created_post.user.id
    assert_equal 1, created_post.up_votes
    assert_response :success
  end

  test "try to create a post without beign logged in" do
    new_post = {
      :link => "http://example.com/", 
      :title => "New Post", 
      :text => "New awesome post"
    }
    post("create", :format => :json, :post => new_post)
    
    created_post = Post.find_by_link("http://example.com/")
    assert created_post.nil?
    assert_response 401
  end

  test "update a post with json format" do
    put "update", 
      :format => :json, 
      :id => @post.id, 
      :auth_token => @user.authentication_token, 
      :post => {:link => "http://example.com/hackful/"}
    
    updated_post = Post.find(@post.id)
    assert !updated_post.nil?
    assert_equal @post.title, updated_post.title
    assert_equal "http://example.com/hackful/", updated_post.link
    assert_equal @post.text, updated_post.text
    assert_equal @user.id, updated_post.user.id
    assert_response :success
  end

  test "update a post without json format" do
    put "update", 
      :id => @post.id, 
      :auth_token => @user.authentication_token, 
      :post => {:link => "http://example.com/hackful/"}
    
    updated_post = Post.find(@post.id)
    assert !updated_post.nil?
    assert_equal @post.title, updated_post.title
    assert_equal "http://example.com/hackful/", updated_post.link
    assert_equal @post.text, updated_post.text
    assert_equal @user.id, updated_post.user.id
    assert_response :success
  end

  test "try update a post without beign logged in" do
    put "update", 
      :format => :json, 
      :id => @post.id, 
      :post => {:link => "http://example.com/hackful/"}

    updated_post = Post.find(@post.id)
    assert !updated_post.nil?
    assert_equal @post.title, updated_post.title
    assert_equal @post.link, updated_post.link
    assert_equal @post.text, updated_post.text
    assert_equal @user.id, updated_post.user.id
    assert_response 401
  end

  test "destroy a post" do
    delete "destroy", 
      :format => :json, 
      :id => @post.id, 
      :auth_token => @user.authentication_token

    assert_raise ActiveRecord::RecordNotFound do 
      deleted_post = Post.find(@post.id)
    end 
    assert_response :success
  end

  test "try to destroy a post without beign logged in" do
    delete "destroy", 
      :format => :json, 
      :id => @post.id

    post = Post.find(@post.id)
    assert !post.nil?
    assert_response 401
  end

  test "get frontpage posts" do
    create_posts(30) {}

    get 'frontpage', :format => :json
    frontpage_json = JSON.parse(response.body)

    assert_equal 20, frontpage_json.length
    assert_response :success
  end

  test "get frontpage posts with page" do
    create_posts(30) {}
    @post.destroy #so it wont come up in our results
    
    get 'frontpage', :format => :json, :page => 2
    frontpage_json = JSON.parse(response.body)

    assert_equal 10, frontpage_json.length
    assert_response :success
  end

  test "get frontpage posts with ranking" do
    create_posts(30) {}
    vote_post(@user, @post)

    get 'frontpage', :format => :json
    frontpage_json = JSON.parse(response.body)
    first_post = frontpage_json[0]

    assert_equal 20, frontpage_json.length
    assert_equal @post.title, first_post["title"]
    assert_equal @post.text, first_post["text"]
    assert_equal @post.link, first_post["link"]
    assert_equal @post.up_votes, first_post["up_votes"]
    assert_response :success
  end

  test "get ask posts" do
    create_posts(30) {|post| post.link = ""}

    get 'ask', :format => :json
    ask_json = JSON.parse(response.body)

    assert_equal 20, ask_json.length
    assert_response :success
  end

  test "get ask posts with page" do
    create_posts(30) {|post| post.link = ""}

    get 'ask', :format => :json, :page => 2
    ask_json = JSON.parse(response.body)

    assert_equal 10, ask_json.length
    assert_response :success
  end

  test "get ask posts with ranking" do
    create_posts(30) {|post| post.link = ""}
    ask_post = Post.where(:link => '').first
    vote_post(@user, ask_post)

    get 'ask', :format => :json
    ask_json = JSON.parse(response.body)
    first_post = ask_json[0]

    assert_equal 20, ask_json.length
    assert_equal ask_post.title, first_post["title"]
    assert_equal ask_post.text, first_post["text"]
    assert_equal ask_post.link, first_post["link"]
    assert_equal ask_post.up_votes, first_post["up_votes"]
    assert_response :success
  end

  test "get new posts" do
    create_posts(30) {}
    
    get 'new', :format => :json
    ask_json = JSON.parse(response.body)
    
    assert_equal 20, ask_json.length
    assert_response :success
  end

  test "get new posts with page" do
    create_posts(30) {}
    @post.destroy #so it wont come up in our results
    
    get 'new', :format => :json, :page => 2
    ask_json = JSON.parse(response.body)
    
    assert_equal 10, ask_json.length
    assert_response :success
  end

  test "get newest posts with date ranking" do
    create_posts(30) {}
    newest_post = Post.find(:first, :order => "created_at DESC")

    get 'new', :format => :json
    new_json = JSON.parse(response.body)
    first_post = new_json[0]

    assert_equal 20, new_json.length
    assert_equal newest_post.title, first_post["title"]
    assert_equal newest_post.text, first_post["text"]
    assert_equal newest_post.link, first_post["link"]
    assert_equal newest_post.up_votes, first_post["up_votes"]
    assert_response :success  
  end

  test "get newest posts with date and vote ranking" do
    create_posts(30) {}
    newest_post = Post.find(:first, :order => "created_at DESC")
    second_post = Post.find(:all, :order => "created_at DESC")[1]
    vote_post(@user, second_post)

    get 'new', :format => :json
    new_json = JSON.parse(response.body)
    first_post = new_json[0]

    assert_equal 20, new_json.length
    assert_equal newest_post.title, first_post["title"]
    assert_equal newest_post.text, first_post["text"]
    assert_equal newest_post.link, first_post["link"]
    assert_equal newest_post.up_votes, first_post["up_votes"]
    assert_response :success  
  end

  private
  def create_posts(num)
    num.times do |i|
      post = Post.new({
        :text => "Post Text #{i}", 
        :link => "http://example.com/example/#{i}", 
        :title => "Post Title #{i}"})
      yield post
      post.user = @user
      post.save
    end
  end 

  def vote_post(user, post)
    user.up_vote(post)
    #post.save
  end
end










