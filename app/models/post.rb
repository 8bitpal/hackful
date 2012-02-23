class Post < ActiveRecord::Base
	has_many :comments, :as => :commentable, :order => "((comments.up_votes - comments.down_votes) - 1 )/POW((((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(comments.created_at)) / 3600 )+2), 1.5) DESC"
	belongs_to :user
	
	attr_accessible :commentable_type, :commentable_id, :title, :text, :link
	
	validates :link, :format => URI::regexp(%w(http https)), :allow_blank => true
	validates :title, :length => { :maximum => 255 }, :allow_blank => false
	validates :text, :length => { :minimum => 2 }, :allow_blank => false
	
	
	make_voteable

	def self.find_ordered(user_id, page = nil)
		if page.nil? or page < 1 then page = 1 end

		offset = ((page-1)*20) 
		date_diff = "((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(posts.created_at))"
		order_algorithm = "((posts.up_votes - posts.down_votes) -1)/
												POW((#{date_diff} / 3600)+2), 1.5)"
		
		return Post.find_by_sql ["SELECT * FROM posts
															WHERE user_id = #{user_id} 
															ORDER BY  #{order_algorithm}
															DESC LIMIT ?, 20", offset]
	end
end
