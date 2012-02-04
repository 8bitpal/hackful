class Comment < ActiveRecord::Base
	include ActionView::Helpers::SanitizeHelper

  def before_create
    self.text = sanitize(self.text)
  end
  
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
end
