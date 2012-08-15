class User < ActiveRecord::Base
  attr_accessible :email, :password, :name, :password_confirmation
  has_secure_password
  has_many :posts
  validates_uniqueness_of :email, :name

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Post.where("user_id = ?", id)
  end
end
