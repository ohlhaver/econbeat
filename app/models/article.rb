class Article < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :catcher

  define_index do
    indexes title
    indexes catcher.author.name, :as => :author
    has created_at
  end



  #def self.search(search)
#	  if search
#	    where 'title LIKE ?', "%#{search}%"
#	  else
#	    scoped
#	  end
#  end
end
