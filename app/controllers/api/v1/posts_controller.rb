class Api::V1::PostsController < Api::ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter :check_login, only: [:up_vote, :down_vote, :create, :edit, :destroy]

  # GET /post/:id
  def show
    post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound if post.nil?
    
    render :json => post
  end

  # PUT /post/:id/vote
  def up_vote
    post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound if post.nil?
    
    current_user.up_vote(post)
    #post.save
    
    render :json => success_message("Successfully voted up post")
  end

  # PUT /post/:id/unvote
  def down_vote
    post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound if post.nil?
    
    current_user.down_vote(post)
    #post.save
    
    render :json => success_message("Successfully voted down post")
  end

  # POST /post
  def create
    return not_loged_in unless user_signed_in?
    
    post = Post.new(params["post"])
    post.user_id = current_user.id

    if post.save
      current_user.up_vote!(post)

      status = :created #:location => post
      response = post
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

  # GET /posts/frontpage
  # GET /posts/frontpage/page/:page
  def frontpage
    render :json => Post.find_frontpage(page_num(params[:page]))
  end

  # GET /posts/new
  # GET /posts/new/page/:page
  def new
    render :json => Post.find_new(page_num(params[:page]))
  end
  
  # GET /posts/ask
  # GET /posts/ask/page/:page
  def ask
    render :json => Post.find_ask(page_num(params[:page]))
  end

  private
  def is_own_post?(post)
    return post.user.eql? current_user
  end
end
