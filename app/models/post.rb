class Post < ActiveRecord::Base
  
  attr_accessible :topic_id, :url
  belongs_to :user
  belongs_to :topic
  belongs_to :utopic
  validates :user_id, presence: true
  #validates :topic_id, presence: true
  validates_presence_of :url, :message => 'is required'
  #validates_presence_of :headline, :message => 'is required'
  validates :headline, presence: true
  

  default_scope order: 'posts.created_at DESC'


  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
end
