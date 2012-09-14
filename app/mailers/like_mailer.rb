class LikeMailer < ActionMailer::Base
  default from: "from@example.com"


  def like_it(post, user)
    @liking_user = user
    @liked_user = post.user
    @subject = @liking_user.name + " liked your post on Jurnalo"
    @post = post
    mail :to => @liked_user.email, :subject => @subject 
  end
end
