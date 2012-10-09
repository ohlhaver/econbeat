class Subscription < ActiveRecord::Base
  attr_accessible :author_id, :user_id
  belongs_to :user
  belongs_to :author
end
