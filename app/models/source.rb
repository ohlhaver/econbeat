class Source < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :feeds
end
