class Author < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :catchers
  has_many :articles, through: :catchers

  define_index do
    indexes name
  end
end
