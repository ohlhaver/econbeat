class Utopic < ActiveRecord::Base
  attr_accessible :topic_id, :user_id
  belongs_to :topic
  belongs_to :user
  has_many :posts
  has_many :filters
  has_many :users, through: :filters
end
