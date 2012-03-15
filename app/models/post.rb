class Post < ActiveRecord::Base
	has_many :comments, :as => :commentable, :order => "((comments.up_votes - comments.down_votes) - 1 )/POW((((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(comments.created_at)) / 3600 )+2), 1.5) DESC"
	belongs_to :user
	
	attr_accessible :commentable_type, :commentable_id, :title, :text, :link
	
	validates :link, :format => URI::regexp(%w(http https)), :allow_blank => true
	validates :title, :length => { :maximum => 255 }, :allow_blank => false
	validates :text, :length => { :minimum => 2 }, :allow_blank => false
	
	
	make_voteable

	def self.find_user_posts(user, page = nil)
		self.find_ordered self.offset(page), "user_id = #{user.id}"
	end

	def self.find_frontpage(page = nil)
		self.find_ordered self.offset(page)
	end

	def self.find_ask(page = nil)
		self.find_ordered self.offset(page), "link = ''"
	end

	def self.find_new(page = nil)
		offset = self.offset(page)
		Post.find(:all, :order => "created_at DESC", :limit => 20, :offset => offset)
	end

	def as_json(options = {})
		super(
			:include => {:user => {:only => [:id, :name]}},
			:except  => :user_id,
			:methods => :comment_count
		)
	end

	def comment_count
		Post.count_all_comments(comments)
	end

	private
	def self.find_ordered(offset, where = nil)
		where = where.nil? ? "" : "WHERE #{where}"
		sql = "SELECT * FROM posts 
					 #{where}
		 			 ORDER BY #{order_algorithm}
			 		 DESC LIMIT ?, 20"

		Post.find_by_sql [sql, offset]
	end

	def self.offset(page = nil)
		if page.nil? or page.blank? or page.to_i < 1 then page = 1 end
		offset = ((page.to_i-1)*20)
	end

	def self.order_algorithm
		date_diff = "((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(posts.created_at))"
		order_algorithm = "((posts.up_votes - posts.down_votes) -1)/
												POW((#{date_diff} / 3600)+2), 1.5)"
	end

	def self.count_all_comments(comments)
    count = 0
    comments.each do |comment|
      count = count + 1
			count += count_all_comments(comment.comments)
    end
    return count
  end
end
