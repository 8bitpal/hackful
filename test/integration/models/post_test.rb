require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:david)
    @john = users(:john)
    @post = posts(:first)
    @post.destroy
  end
 
  def teardown
    @user = nil
    @john = nil
  end

  test "find user posts" do
    create_posts(30) {}

    posts = Post.find_user_posts(@user)

    assert_equal 20, posts.length
    posts.each do |post|
      assert_equal @user.id, post.user.id
    end
  end

  test "find user posts with page" do
    create_posts(30) {}

    posts = Post.find_user_posts(@user, 2)

    assert_equal 10, posts.length
    posts.each do |post|
      assert_equal @user.id, post.user.id
    end
  end

  test "find frontpage posts" do
    # create 30 posts and upvote one of them
    voted_post = nil
    create_posts(30) { |post|
      if voted_post.nil? then
        @john.up_vote(post)
        voted_post = post
      end
    }

    posts = Post.find_frontpage
    first_post = posts.first
    
    assert_equal voted_post.id, first_post.id
    assert_equal 20, posts.length
  end

  test "find frontpage posts with page" do
    # create 30 posts and upvote one of them
    voted_post = nil
    create_posts(30) { |post|
      if voted_post.nil? then
        @john.up_vote(post)
        voted_post = post
      end
    }

    posts = Post.find_frontpage(2)
    
    assert_equal 10, posts.length
  end

  test "find ask posts" do
    # create 30 ask posts without links
    create_posts(30) { |post| post.link = "" }

    posts = Post.find_ask
    first_post = posts.first

    assert_equal 20, posts.length
    posts.each do |post|
      assert_equal "", post.link
    end
  end

  test "find ask posts with page" do
    # create 30 ask posts without links
    create_posts(30) { |post| post.link = "" }

    posts = Post.find_ask(2)
    first_post = posts.first

    assert_equal 10, posts.length
    posts.each do |post|
      assert_equal "", post.link
    end
  end

  test "find new posts" do
    # create 30 ask posts and hold the last one
    last_post = nil 
    create_posts(30) { |post| last_post = post }
    
    # created ten seconds later than other posts
    last_post.created_at = Time.now + 10.seconds
    last_post.save

    posts = Post.find_new
    first_post = posts.first

    assert_equal 20, posts.length
    assert_equal last_post.id, first_post.id
  end

  test "find new posts with page" do
    # create 30 ask posts
    create_posts(30) {}

    posts = Post.find_new(2)
    
    assert_equal 10, posts.length
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
end