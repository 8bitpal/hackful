class ContentController < ApplicationController
  def frontpage
		@posts = Post.find_by_sql("SELECT * FROM posts ORDER BY ((posts.up_votes - posts.down_votes) -1 )/POW((((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(posts.created_at)) / 3600 )+2), 1.5) DESC LIMIT 15")
  end

  def new
		@posts = Post.find(:all, :order => "created_at DESC", :limit => 15)
  end

end
