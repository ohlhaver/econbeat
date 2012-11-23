class Author < ActiveRecord::Base
  attr_accessible :name, :economist, :hidden, :img_url
  has_many :catchers
  has_many :articles, through: :catchers
  has_many :subscriptions
  has_many :actions, through: :catchers
  has_many :users, through: :subscriptions

def to_param
  "#{id}-#{name.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
end


  define_index do
    indexes name
    has hidden
  end
end
