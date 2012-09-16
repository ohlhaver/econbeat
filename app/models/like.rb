class Like < ActiveRecord::Base
  #attr_accessible :fbid, :post_id, :user_id
  belongs_to :user
  belongs_to :post
end
