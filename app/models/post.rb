class Post < ActiveRecord::Base
  attr_accessible :category_id, :url
  belongs_to :user
  validates :user_id, presence: true
  validates :url, presence: true

  default_scope order: 'posts.created_at DESC'
end
