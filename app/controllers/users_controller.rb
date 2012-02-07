class UsersController < ApplicationController	

	def show
		@user = User.find_by_name(params[:name].to_s)
		
		params[:page].nil? ? @page = 0 : @page = params[:page].to_i
		@posts = Post.find_by_sql ["SELECT * FROM posts WHERE user_id = #{@user.id} ORDER BY ((posts.up_votes - posts.down_votes) -1 )/POW((((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(posts.created_at)) / 3600 )+2), 1.5) DESC LIMIT ?, 20", (@page*20)]		
	end

end