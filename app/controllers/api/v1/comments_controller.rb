class Api::V1::CommentsController < Api::ApplicationController
  before_filter :authenticate_user!, :except => [:show, :show_post_comments, :show_user_comments]
  before_filter :check_login, only: [:vote_up, :create, :edit, :destroy]

  # GET /comment/:id
  def show
    comment = Comment.find(params[:id])
    raise ActiveRecord::RecordNotFound if post.nil?

    render :json => comment
  end

  # GET /comments/post/:id
  def show_post_comments
    post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound if post.nil?

    render :json => post.comments
  end

  # GET /comments/user/:name
  def show_user_comments
    user = User.find(params[:name])
    raise ActiveRecord::RecordNotFound if user.nil?

    render :json => user.comments
  end

  # PUT /comment/:id/vote  
  def vote_up
    current_user.up_vote(Comment.find(params[:id]))
  end

  # PUT /comment/:id/unvote 
  def unvote
    # TODO: unvote?
    current_user.up_vote(Comment.find(params[:id]))
  end

  # POST /comment
  def create
    comment = Comment.new(@params)
    comment.user_id = current_user.id

    if comment.save
      current_user.up_vote!(@comment)
      render :json => @comment, :status => :created, :location => @comment
    else
      render :json => comment.errors, :status => :unprocessable_entity
    end
  end

  # PUT /comment/:id
  def update
    comment = Comment.find(params[:id])
    raise ActiveRecord::RecordNotFound if comment.nil?
    raise "NoPermission" unless is_own_comment?(comment)

    if comment.update_attributes(@params)
      head :ok
    else
      failure = failure_message("Couldn't update comment", {:errors => comment.errors})
      render :json => failure, :status => :unprocessable_entity
    end
  end

  # DELETE /comment/:id
  def destroy
    comment = Comment.find(params[:id])
    raise ActiveRecord::RecordNotFound if comment.nil?
    raise "NoPermission" unless is_own_comment?(comment)

    comment.destroy
    head :ok
  end

  private
  def is_own_comment?(comment)
    return comment.user.eql? current_user
  end
end