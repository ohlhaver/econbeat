class Post < ActiveRecord::Base
  
  attr_accessible :topic_id, :url
  belongs_to :user
  belongs_to :topic
  belongs_to :utopic
  validates_uniqueness_of :fbid
  #validates :user_id, presence: true
  #validates :topic_id, presence: true
  #validates_presence_of :url, :message => 'is required'
  #validates_presence_of :headline, :message => 'is required'
  #validates :headline, presence: true
  
  after_create :ensure_picture, :filter_bad_posts

  default_scope order: 'posts.created_at DESC'


  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end

  def ensure_picture
    self.picture ="https://fbexternal-a.akamaihd.net/safe_image.php" if self.picture == nil
    self.save
  end

  def filter_bad_posts
    if self.url.first == "/" || (self.url.starts_with? "http://www.facebook.com/")
      self.hidden = true
      self.save
    end
  end

end
