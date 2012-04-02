class UserMailer < ActionMailer::Base
  helper :application

  default from: "mail@hackful.com"

  def receive(email)
		commentable_string = email.subject.scan(/\(\w{1,} #\d*\)/mi)[0]
		commentable_type = commentable_string.scan(/[a-zA-Z]+/mi)[0]
		commentable_id = commentable_string.scan(/[0-9]{1,}/)[0].to_i
		text = email.body.decoded.gsub(/(^>.*)|((\w*\s*)[0-9]{1,}.*:$)/mi, "")
		Comment.new(commentable_type: commentable_type, commentable_id: commentable_id, text: text, user_id: User.find_by_email(email.from.first).id).save! unless User.find_by_email(email.from.first).nil?
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.newsletter.subject
  #
  def newsletter(user, subject, text)
    @user = user
    @text = text

    mail(to: user.email, subject: subject)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify.subject
  #
  def notify
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
