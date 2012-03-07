class DataSet < ActiveRecord::Base
	#Initial table structure, could be changed in favor of more dynamic structure

	attr_accessible :contact_me

	belongs_to :user
end
