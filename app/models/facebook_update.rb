class FacebookUpdate < ActiveRecord::Base
  attr_accessible :id, :type
  after_create :draw_realtime_posts

  def draw_realtime_posts
  	@user = User.find_by_uid(self.uid)
  	@user.delay.sync_fb
  end
end
