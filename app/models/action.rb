class Action < ActiveRecord::Base
  attr_accessible :action_type, :obj_id, :object_type, :subject_id, :subject_type
  belongs_to :user, class_name: "User"
  belongs_to :author, class_name: "Author"
  belongs_to :article, class_name: "Article"
  belongs_to :author_obj, class_name: "Author"
  belongs_to :post, class_name: "Post"


  default_scope order: 'actions.created_at DESC'
  paginates_per 50

  define_index do
    indexes article.title, :as => :title
    indexes post.headline, :as => :headline
    indexes author.name, :as => :author
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
    where("(user_id IN (#{followed_user_ids}) OR user_id = :user_id) and subject_type = 1", 
          user_id: user.id)
  end

  def self.from_authors_followed_by(user)
    followed_author_ids = "SELECT author_id FROM subscriptions
                         WHERE user_id = :user_id"
    where("(author_id IN (#{followed_author_ids})) and subject_type = 2", 
          user_id: user.id)
  end

end
