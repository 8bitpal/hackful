class Api::V1::PostsController < Api::ApplicationController
  before_filter :check_login, only: [:up_vote, :down_vote, :create, :update, :destroy]
  before_filter :set_current_user

  # GET /post/:id
  def show
    post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound if post.nil?
    
    render :json => post
  end

  # GET /posts/user/:id(/:page)
  def show_user_posts
    user = User.find(params[:id])
    posts = Post.find_user_posts(user, params[:page])
    
    render :json => posts
  end

  # PUT /post/:id/upvote
  def up_vote
    post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound if post.nil?
    
    current_user.up_vote(post)
    
    render :json => success_message("Successfully voted up post")
  end

  # PUT /post/:id/unvote
  def down_vote
    post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound if post.nil?
    
    current_user.down_vote(post)
    
    render :json => success_message("Successfully voted down post")
  end

  # POST /post
  def create
    post = Post.new(params["post"])
    post.user_id = current_user.id

    if post.save
      current_user.up_vote!(post)
      status = :created
      response = success_message("Successfully created post")
    else
      status = :unprocessable_entity
      errors = {:errors => post.errors}
      response = failure_message("Couldn't create post", errors)
    end

    render :json => response, :status => status
  end

  # PUT /post/:id
  def update
    post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound if post.nil?
    raise "NoPermission" unless is_own_post?(post)
    
    if post.update_attributes(params["post"])
      #head :ok
      render :json => {:post => post, :params => params}
    else
      failure = failure_message("Couldn't update user", {:errors => post.errors})
      render :json => failure, :status => :unprocessable_entity
    end
  end

  # DELETE /post/:id
  def destroy
    post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound if post.nil?
    raise "NoPermission" unless is_own_post?(post)

    post.destroy
    head :ok
  end

  # GET /posts/frontpage(/:page)
  def frontpage
    user_signed_in?
    return render :json => Post.find_frontpage(params[:page])
  end

  # GET /posts/new(/:page)
  def new
    return render :json => Post.find_new(params[:page])
  end
  
  # GET /posts/ask(/:page)
  def ask
    return render :json => Post.find_ask(params[:page])
  end

  private
  def is_own_post?(post)
    return post.user.eql? current_user
  end

  def set_current_user
    User.current_user = current_user if user_signed_in?
  end
end
