class Post < ActiveRecord::Base
	has_many :comments, :as => :commentable, :order => "((comments.up_votes - comments.down_votes) - 1 )/POW((((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(comments.created_at)) / 3600 )+2), 1.5) DESC"
	belongs_to :user
	
	attr_accessible :commentable_type, :commentable_id, :title, :text, :link
	
	validates :link, :format => URI::regexp(%w(http https)), :allow_blank => true
	validates :title, :length => { :maximum => 255 }, :allow_blank => false
	validates :text, :length => { :minimum => 2 }, :allow_blank => false
	
	
	make_voteable
end
