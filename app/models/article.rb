class Article < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :feed
  belongs_to :catcher
  default_scope order: 'articles.created_at DESC'
  after_create :publish_action
  has_many :likes

  def to_param
  "#{id}-#{title.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}" if title
  end


  #define_index do
  #  indexes title
  #  indexes catcher.author.name, :as => :author
  #  has created_at
  #end



  def publish_action
  	a=Action.new
  	a.publish_article(self)
  end

  #def self.search(search)
#	  if search
#	    where 'title LIKE ?', "%#{search}%"
#	  else
#	    scoped
#	  end
#  end
end
