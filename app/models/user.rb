class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
	
	has_many :votes, :as => :voteable
	has_many :comments
	has_many :posts
	
	validates_uniqueness_of :name
	validates_format_of :name, :with => /\A[a-zA-Z0-9]+\z/i,
	:message => "can only contain letters and numbers."
	
	make_voter
end

