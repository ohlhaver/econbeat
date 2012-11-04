class UserMailer < ActionMailer::Base
  default from: "Jurnalo"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def send_message(text, user)
    @message = text
    @user= user
    mail :to => 'ohlhaver@gmail.com', :subject => "FEEDBACK"

  end

  def daily_mail(user, actions, user_actions)
    @from         = "\"Jurnalo\" <jurnalo.service@gmail.com>"
    @user = user
    @subject = "Daily Digest"
    @actions = actions
    @user_actions = user_actions
    mail :to => user.email, :subject => @subject 

  end
end
