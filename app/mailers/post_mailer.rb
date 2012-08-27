class PostMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.post_mailer.notification.subject
  #
  def notification(post, alerted_users)

    @post = post
    @subject = @post.user.name + " sent you an article"

    #alerted_users = post.user.followers - post.utopic.users #if post.utopic.users != nil
    #receipients = alerted_users.map{|u| u[:email]}
    receipients = alerted_users.collect(&:email).join(",") 

    mail :to => "followers@jurnalo.com", :bcc => receipients, :subject =>  @subject 
  end
end
