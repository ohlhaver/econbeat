class Action < ActiveRecord::Base
  attr_accessible :action_type, :obj_id, :object_type, :subject_id, :subject_type
  belongs_to :user, class_name: "User"
  belongs_to :catcher, class_name: "Catcher"
  belongs_to :article, class_name: "Article"
  belongs_to :author_obj, class_name: "Author"
  belongs_to :post, class_name: "Post"
  has_many :comments
  has_many :commenters, through: :comments, source: :user


  default_scope order: 'actions.created_at DESC'
  paginates_per 50

  define_index do
    indexes article.title, :as => :title
    indexes post.headline, :as => :headline
    indexes catcher.author.name, :as => :author
    indexes action_type, :as => :type
    has created_at, action_type
  end

  def new_post(post)
  	self.subject_type=1
  	self.user_id=post.user_id
  	self.action_type=1
  	self.object_type=1
  	self.post_id=post.id

  	self.save
  end

  def like_post(like)
  	self.subject_type=1
  	self.user_id=like.user_id
  	self.action_type=2
  	self.object_type=1
  	self.post_id=like.post_id

  	self.save
  end

  def like_article(like)
  	self.subject_type=1
  	self.user_id=like.user_id
  	self.action_type=2
  	self.object_type=2
  	self.article_id=like.article_id

  	self.save
  end

  def like_author(author, user)
    self.subject_type=1
    self.user_id=user.id
    self.action_type=2
    self.object_type=3
    self.author_obj_id=author.id

    self.save
  end

  def subscribe_author(subscription)
  	self.subject_type=1
  	self.user_id=subscription.user_id
  	self.action_type=3
  	self.object_type=3
  	self.author_obj_id=subscription.author_id

  	self.save
  end

  def star_author(subscription)
    self.subject_type=1
    self.user_id=subscription.user_id
    self.action_type=4
    self.object_type=3
    self.author_obj_id=subscription.author_id

    self.save
  end

  def comment_on_post(comment)
    self.subject_type=1
    self.user_id=comment.user_id
    self.action_type=5
    self.object_type=1
    self.post_id=comment.post_id

    self.save
  end

  def comment_on_action(comment)
    self.subject_type=1
    self.user_id=comment.user_id
    self.action_type=5
    self.object_type=2
    self.article_id=comment.article_id

    self.save
  end

  def join(user)
    self.subject_type=1
    self.user_id=user.id
    self.action_type=6
    self.save

  end


  def publish_article(article)
    self.subject_type=2
    self.author_id=article.catcher.author_id
    self.action_type=7
    self.object_type=2
    self.article_id=article.id

    self.save
  end

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("(user_id IN (#{followed_user_ids}) OR user_id = :user_id)", 
          user_id: user.id)
  end

  def self.from_authors_followed_by(user)
    followed_author_ids = "SELECT author_id FROM subscriptions
                         WHERE user_id = :user_id"
    where("(author_id IN (#{followed_author_ids})) and subject_type = 2", 
          user_id: user.id)
  end

  def self.from_authors_starred_by(user)
      followed_author_ids = "SELECT author_id FROM subscriptions
                           WHERE user_id = :user_id and starred = true"
      where("(author_id IN (#{followed_author_ids})) and subject_type = 2", 
            user_id: user.id)
  end

  def self.latest_from_users_followed_by(user)
    actions = []   
    users = user.followed_users 
    users.each do |u|
      actions += Array.wrap(u.actions.where(:hidden=>nil).first)
    end
    actions += Array.wrap(user.actions.where(:hidden=>nil).first)

  end  

  def self.latest_from_other_users_followed_by(user)
    actions = []   
    users = user.followed_users 
    users.each do |u|
      actions += Array.wrap(u.actions.where(:hidden=>nil).first)
    end
    return actions
  end  




  def self.latest_from_authors_followed_by(user)
    

    actions = []                    
    user.authors.each do |a|
      actions += Array.wrap(a.actions.first) if a.actions.first && a.actions.first.created_at >= 2.days.ago
    end

    return actions

  end

  def self.latest_from_authors_starred_by(user)
    

    actions = []                    
    user.starred_subscriptions.each do |a|
      actions += Array.wrap(a.author.actions.first)
    end

    return actions

  end

  def self.latest_from_top_authors
    


    actions = []  
    authors = []
    @authors = Econlist.last.top_authors.split(",").first(100)                  
    @authors.each do |a|
      author = Author.find(a)
      actions += Array.wrap(author.actions.first) if author.actions.first && author.actions.first.created_at >= 1.days.ago
      authors += Array.wrap(Author.find(a))
    end
    actions = (actions.first(25)).sort_by{|e| -e[:id]}
    authors = authors.first(25)




    return actions, authors

  end



  def hide
    self.hidden=true
    self.save
  end

end
