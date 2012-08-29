class InvitationMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.invitation.subject
  #
  def invitation(invitation, signup_url)
    @invitation = invitation 
    @subject = @invitation.sender.name + ' invited you'
    @signup_url = signup_url
    mail :to => invitation.recipient_email, :subject => @subject
  end
end
