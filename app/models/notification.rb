class Notification < ActiveRecord::Base
	belongs_to :alerted, :polymorphic => true
	belongs_to :alertable, :polymorphic => true
	
	attr_accessible :alertable_type, :alertable_id, :user_id, :alerted_type, :alerted_id
end
