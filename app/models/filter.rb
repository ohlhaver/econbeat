class Filter < ActiveRecord::Base
  attr_accessible :user_id, :utopic_id
  belongs_to :user
  belongs_to :utopic
  has_many :utopics
  has_many :posts, through: :utopics
  
end
