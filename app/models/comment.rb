class Comment < ActiveRecord::Base
  attr_accessible  :text
  belongs_to :user
  belongs_to :post
  validates_uniqueness_of :fbid

end
