class Comment < ActiveRecord::Base
	belongs_to :commentable, :polymorphic => true
	belongs_to :user
	
	attr_accessible :commentable_type, :commentable_id, :text
	
	has_many :comments, :as => :commentable
	
	make_voteable
	
	def root
		commentable = self.commentable
		while commentable.class == "Comment"
			commentable = commentable.commentable
		end
		commentable
	end
end
