class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :token_authenticatable

  cattr_accessor :current_user

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :data_set_attributes
	
	has_many :votes, :as => :voteable
	has_many :comments
	has_many :posts
	has_many :notifications, :order => "created_at DESC"
	has_many :admin_auths

	has_one :data_set
	accepts_nested_attributes_for :data_set
	
	validates_uniqueness_of :name
	validates_format_of :name, :with => /\A[a-zA-Z0-9]+\z/i,
	:message => "can only contain letters and numbers."
	
	make_voter

  def all_notifications
    {
      :new_notifications => self.notifications.where(:unread => true),
      :old_notifications => self.notifications.find(:all, 
        :conditions => { :unread => false }, :limit => 20)      
    }
  end
end

