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

    mail :to => "followers@EconBloggers.com", :bcc => receipients, :subject =>  @subject 
  end


  def comment(post, user, text)
    @commenting_user = user
    @addressed_user = post.user
    @subject = @commenting_user.name + " commented on your like action"
    @post = post
    @text = text
    mail :to => @addressed_user.email, :subject => @subject 
  end

  def also_comment(post, user, text)
    @commenting_user = user
    #@addressed_user = post.user
    alerted_users = post.commenters.uniq - Array.wrap(post.user) - Array.wrap(user)
    receipients = alerted_users.collect(&:email).join(",") 
    if post.user == user
      @subject = @commenting_user.name + " also commented on her/his like action"
    else
      @subject = @commenting_user.name + " also commented on the like action by " + post.user.name
    end
    @post = post
    @text = text
    mail :to => "discussion@EconBloggers.com", :bcc => receipients, :subject =>  @subject  
  end
end
