class Catcher < ActiveRecord::Base
  belongs_to :author
  has_many :articles
  has_many :actions
  # attr_accessible :title, :body
end
