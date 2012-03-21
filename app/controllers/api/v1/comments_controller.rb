class Api::V1::CommentsController < Api::ApplicationController
  before_filter :check_login, only: [:up_vote, :down_vote, :create, :update, :destroy]
  before_filter :set_current_user

  # GET /comment/:id
  def show
    comment = Comment.find(params[:id])
    raise ActiveRecord::RecordNotFound if comment.nil?

    render :json => comment
  end

  # GET /comments/post/:id
  def show_post_comments
    post = Post.find(params[:id])
    raise ActiveRecord::RecordNotFound if post.nil?
    
    render :json => all_comments(post)
  end

  # GET /comments/user/:id
  def show_user_comments
    user = User.find(params[:id])
    raise ActiveRecord::RecordNotFound if user.nil?

    render :json => user.comments
  end

  # PUT /comment/:id/upvote
  def up_vote
    comment = Comment.find(params[:id])
    raise ActiveRecord::RecordNotFound if comment.nil?
    
    current_user.up_vote(comment)
    
    render :json => success_message("Successfully up voted comment")
  end

  # PUT /comment/:id/downvote 
  def down_vote
    comment = Comment.find(params[:id])
    raise ActiveRecord::RecordNotFound if comment.nil?
    
    current_user.down_vote(comment)
    
    render :json => success_message("Successfully down voted comment")
  end

  # POST /comment
  def create
    comment = Comment.new(params["comment"])
    comment.user_id = current_user.id

    if comment.save
      current_user.up_vote!(comment)
      render :json => comment, :status => :created
    else
      render :json => comment.errors, :status => :unprocessable_entity
    end
  end

  # PUT /comment/:id
  def update
    comment = Comment.find(params[:id])
    raise ActiveRecord::RecordNotFound if comment.nil?
    raise "NoPermission" unless is_own_comment?(comment)

    if comment.update_attributes(params["comment"])
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

  def all_comments(commentable)
    children = []
    commentable.comments.each do |comment|
      comment_json = comment.as_json
      comment_json.merge! ({:children => all_comments(comment)})
      
      children.push(comment_json)
    end
    return children
  end

  def set_current_user
    User.current_user = current_user if user_signed_in?
  end
end