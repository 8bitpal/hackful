class AdminController < ApplicationController
  authorize_resource :class => false
  
  def mail

  end
  
  def send_newsletter
  	if user_signed_in?
  		unless params[:test]
			User.all.each do |user|
				UserMailer.delay.newsletter(user, params[:subject], params[:text])
			end
		else
			UserMailer.delay.newsletter(current_user, params[:subject], params[:text])
		end
		redirect_to "/admin/mail", notice: "Mail sent"
  	end
  end

  def spam
    
  end

  def save_spam_settings
    @spammers = JSON(params[:spammers])
    @spammers.each do |spammer|
      Spammer.create(user_id: User.find_by_name(spammer["name"]).id, reason: spammer["reason"])
    end
  end

end
