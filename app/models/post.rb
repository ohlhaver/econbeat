class Post < ActiveRecord::Base
  acts_as_list
  attr_accessor :box, :count, :author, :fb_object
  
  attr_accessible :topic_id, :url, :facebook, :email, :public, :headline, :author, :description, :via_id, :picture
  belongs_to :user
  belongs_to :topic
  belongs_to :utopic
  has_many :comments
  has_many :commenters, through: :comments, source: :user
  has_many :likes
  has_many :likers, through: :likes, source: :user
  validates_uniqueness_of :fbid
  belongs_to :via, class_name: "User"
  #validates :user_id, presence: true
  #validates :topic_id, presence: true
  #validates_presence_of :url, :message => 'is required'
  #validates_presence_of :headline, :message => 'is required'
  #validates :headline, presence: true
  
  after_create :ensure_picture, :filter_bad_posts
  #before_save :ensure_position

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

def ensure_position
  if self.position == nil 
    self.position = 0 
  end
end


end
