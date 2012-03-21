class Comment < ActiveRecord::Base
	include ActionView::Helpers::SanitizeHelper
  
  after_create { |comment| Notification.new(:user_id => comment.commentable.user_id, :alerted_type => comment.commentable.class.name, :alerted_id => comment.commentable.id, :alertable_type => comment.class.name, :alertable_id => comment.id ).save! }
  
	belongs_to :commentable, :polymorphic => true
	belongs_to :user
	
	attr_accessible :commentable_type, :commentable_id, :text
	
	has_many :comments, :as => :commentable
	
	make_voteable
	
	validates :text, :length => { :minimum => 2 }, :allow_blank => false
	
	def root
		commentable = self.commentable
		while commentable.class == "Comment"
			commentable = commentable.commentable
		end
		commentable
	end

	def as_json(options = {})
		super(
			:include => {:user => {:only => [:id, :name]}},
			:except  => [:user_id, :down_votes, :commentable_type],
			:methods => :voted
		)
	end

	def voted
		current_user = User.current_user
		unless current_user.blank?
			current_user.voted?(self)
		else
			false
		end 
	end
end
