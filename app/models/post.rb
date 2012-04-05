class Post < ActiveRecord::Base
	include Rails.application.routes.url_helpers

	has_many :comments, :as => :commentable, :order => "((comments.up_votes - comments.down_votes) - 1 )/POW((((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(comments.created_at)) / 3600 )+2), 1.5) DESC"
	belongs_to :user
	
	attr_accessible :commentable_type, :commentable_id, :title, :text, :link
	
	validates :link, :format => URI::regexp(%w(http https)), :allow_blank => true
	validates :title, :length => { :maximum => 255 }, :allow_blank => false
	validates :text, :length => { :minimum => 2 }, :allow_blank => false
	
	make_voteable

	# Finds user posts with given page and standard ordering 
	# (see <tt>Post.order_algorithm</tt> for order algorithm).
	def self.find_user_posts(user, page = nil)
		self.find_ordered self.offset(page), "user_id = #{user.id}"
	end

	# Finds frontpage posts with given page and standard ordering 
	# (see <tt>Post.order_algorithm</tt> for order algorithm).
	def self.find_frontpage(page = nil)
		self.find_ordered self.offset(page)
	end

	# Finds ask posts with given page and standard ordering 
	# (see <tt>Post.order_algorithm</tt> for order algorithm).
	def self.find_ask(page = nil)
		self.find_ordered self.offset(page), "link = ''"
	end

	# Finds new posts with given page and DESC ordering.
	def self.find_new(page = nil)
		offset = self.offset(page)
		Post.find(:all, :order => "created_at DESC", :limit => 20, :offset => offset)
	end

	# Overrides standard as_json and a adds user, comment count, path and vote 
	# status to post json.
	#
	# ==== Examples
	# 
	# [{
	#		"created_at":"2012-03-24T10:11:14Z",
	#		"down_votes":0,
	#		"id":1,
	#		"link":"http://http://example.com/",
	#		"text":"Example Post Text",
	#		"title":"Example Post Title",
	#		"up_votes":4,
	#		"updated_at":"2012-03-26T18:48:19Z",
	#		"comment_count":6,
	#		"path":"/posts/1",
	#		"voted":false,
	#		"user":{
	#			"id":1,
	#			"name":"Oemera"
	#		}
	# }, ...]
	def as_json(options = {})
		super(
			:include => {:user => {:only => [:id, :name]}},
			:except  => :user_id,
			:methods => [:comment_count, :path, :voted]
		)
	end

	# Returns comment count.
	def comment_count
		Post.count_all_comments(comments)
	end

	# Return path for post.
	def path
		post_path(self)
	end

	# Checks if current logged in user has upvoted the post or not.
	# If no current user exists, it will return false.
	def voted
		current_user = User.current_user
		unless current_user.blank?
			current_user.voted?(self)
		else
			false
		end 
	end
	
	private

	# Finds posts with standard algorithm, a offset and a optional where clause.
	# If no where clause is given the where whole where clause will be left out.
	# However you the where clause should be written in SQL syntax and shouldn't 
	# contain the <tt>WHERE</tt> keyword.
	# 
	# ==== Examples
	# 
	# 	Post.find_ordered(0, "user_id = 1")
	# 	Post.find_ordered(20, "link = ''")
	# 	Post.find_ordered(0, nil)
	#
	def self.find_ordered(offset, where = nil)
		where = where.nil? ? "" : "WHERE #{where}"
		sql = "SELECT * FROM posts 
					 #{where}
		 			 ORDER BY #{order_algorithm}
			 		 DESC LIMIT ?, 20"

		Post.find_by_sql [sql, offset]
	end

	# Converts a page number into offset for limiting database queries.
	# If page is nil or smaller than <tt>1</tt> page value will be set 
	# to <tt>1</tt>. 
	def self.offset(page = nil)
		if page.nil? or page.blank? or page.to_i < 1 then page = 1 end
		offset = ((page.to_i-1)*20)
	end

	# Contains the order algorithm for content pages like frontpage, ask and new.
	# Whole method is static and has no dynimcs in it but it makes the SQL 
	# statements a lot easier to read.
	def self.order_algorithm
		date_diff = "((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(posts.created_at))"
		order_algorithm = "((posts.up_votes - posts.down_votes) -1)/
												POW((#{date_diff} / 3600)+2), 1.5)"
	end

	# Counts all comments of a post recursively.
	# This is needed cause all comments are stored as children of a commentable 
	# object. So we can't just do <tt>post.comments.length</tt>. We need to 
	# iterate through all comments children recursively.
	def self.count_all_comments(comments)
    count = 0
    comments.each do |comment|
      count = count + 1
			count += count_all_comments(comment.comments)
    end
    return count
  end
end
