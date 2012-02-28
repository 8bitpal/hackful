class ContentController < ApplicationController
  def frontpage
		@posts = Post.find_frontpage(params[:page])

    respond_to do |f|
			f.html
			f.rss { render :layout => false }
		end
  end

  def new
		@posts = Post.find_new(params[:page])
    
    respond_to do |f|
			f.html
			f.rss { render :layout => false }
		end
  end
  
  def ask
		@posts = Post.find_ask(params[:page])
    
		respond_to do |f|
			f.html
			f.rss { render :layout => false }
		end
  end
  
  def about
		respond_to do |f|
			f.html
		end
  end
  
  def notifications
    notifications = current_user.all_notifications
    @new_notifications = notifications[:new_notifications]
    @old_notifications = notifications[:old_notifications]
    @comment = Comment.new
    respond_to do |f|
      f.html
    end
  end

end
