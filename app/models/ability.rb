class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    unless user.id.nil?
			can [:read, :create, :vote_up, :vote_down], [Post, Comment]
			can [:update, :destroy], [Post, Comment], :user_id => user.id
		end
		can [:read], :all
		can :create, User
  end
end
