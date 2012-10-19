class Comment < ActiveRecord::Base
  attr_accessible  :text
  belongs_to :user
  belongs_to :post
  belongs_to :action
  validates_uniqueness_of :fbid

end
