class ContentController < ApplicationController
  def frontpage
		@page = page_number(params[:page])
    @posts = Post.find_frontpage(@page)
    @show_next_link = (Post.find_frontpage(@page+1).length > 0)

    respond_to do |f|
			f.html
			f.rss { render :layout => false }
		end
  end

  def new
    @page = page_number(params[:page])
		@posts = Post.find_new(@page)
    @show_next_link = (Post.find_frontpage(@page+1).length > 0)

    respond_to do |f|
			f.html
			f.rss { render :layout => false }
		end
  end
  
  def ask
    @page = page_number(params[:page])
		@posts = Post.find_ask(@page)
    @show_next_link = (Post.find_frontpage(@page+1).length > 0)

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
