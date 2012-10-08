class Catcher < ActiveRecord::Base
  belongs_to :author
  has_many :articles
  # attr_accessible :title, :body
end
