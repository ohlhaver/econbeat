class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  after_create :alert_followed_user
  #validates :followed_id, :uniqueness => {:scope => :follower_id}

  def alert_followed_user
  	#@alerted_user = User.find(followed_id)
  	FollowerMailer.delay.follower(self)
  end
end
