class ContentController < ApplicationController
  def frontpage
		params[:page].nil? ? @page = 0 : @page = params[:page].to_i
		@posts = Post.find_by_sql ["SELECT * FROM posts ORDER BY ((posts.up_votes - posts.down_votes) -1 )/POW((((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(posts.created_at)) / 3600 )+2), 1.5) DESC LIMIT ?, 20", (@page*20)]

		respond_to do |f|
			f.html
			f.rss { render :layout => false }
		end
  end

  def new
		params[:page].nil? ? @page = 0 : @page = params[:page].to_i
		@posts = Post.find(:all, :order => "created_at DESC", :limit => 20, :offset => (@page*20))
		
		respond_to do |f|
			f.html
			f.rss { render :layout => false }
		end
  end
  
  def ask
		params[:page].nil? ? @page = 0 : @page = params[:page].to_i
		@posts = Post.find_by_sql ["SELECT * FROM posts WHERE posts.link = '' ORDER BY ((posts.up_votes - posts.down_votes) -1 )/POW((((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(posts.created_at)) / 3600 )+2), 1.5) DESC LIMIT ?, 20", (@page*20)]

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
		@new_notifications = current_user.notifications.where(:unread => true)
		@old_notifications = current_user.notifications.find(:all, :conditions => { :unread => false }, :limit => 20)
		@comment = Comment.new
		respond_to do |f|
			f.html
		end
  end

end
