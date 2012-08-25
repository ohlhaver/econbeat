class FollowerMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.follower_mailer.follower.subject
  #
  def follower(relationship)
    @follower = relationship.follower
    @followed = relationship.followed
    mail :to => @followed.email, :subject => "New follower"
  end
end
