class User < ActiveRecord::Base
  attr_accessible :email, :password, :name, :password_confirmation
  has_secure_password
  has_many :posts
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :utopics
  has_many :filters


  validates_uniqueness_of :email, :name

  def feed
    a = Post.from_users_followed_by(self)
    
    self.filters.each do |f|
      a = a - f.utopic.posts if f.utopic != nil
    end
    return a
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end


end
