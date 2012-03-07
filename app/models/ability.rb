class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    unless user.id.nil?
			can [:read, :create, :vote_up, :vote_down], [Post, Comment]
			can [:update, :destroy], [Post, Comment], :user_id => user.id
			user.admin_auths.each do |auth|
				(defined?(auth.resource.upcase) == "constant") ? (can auth.action.to_sym, auth.resource.constantize) : (can auth.action.to_sym, auth.resource.to_sym)
			end
		end
		can [:read], :all
		can :create, User
  end
end
