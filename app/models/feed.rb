class Feed < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :articles
  belongs_to :source
end
