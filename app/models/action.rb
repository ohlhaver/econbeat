class Action < ActiveRecord::Base
  attr_accessible :action_type, :object_id, :object_type, :subject_id, :subject_type

  def new_post(post)
  	self.subject_type=1
  	self.subject_id=post.user_id
  	self.action_type=1
  	self.object_type=1
  	self.object_id=post.id

  	self.save
  end

  def like_post(like)
  	self.subject_type=1
  	self.subject_id=like.user_id
  	self.action_type=2
  	self.object_type=1
  	self.object_id=like.post_id

  	self.save
  end

  def like_article(like)
  	self.subject_type=1
  	self.subject_id=like.user_id
  	self.action_type=2
  	self.object_type=2
  	self.object_id=like.article_id

  	self.save
  end

  def subscribe_author(subscription)
  	self.subject_type=1
  	self.subject_id=subscription.user_id
  	self.action_type=3
  	self.object_type=3
  	self.object_id=subscription.author_id

  	self.save
  end

  def star_author(subscription)
    self.subject_type=1
    self.subject_id=subscription.user_id
    self.action_type=4
    self.object_type=3
    self.object_id=subscription.author_id

    self.save
  end

  def comment_on_post(comment)
    self.subject_type=1
    self.subject_id=comment.user_id
    self.action_type=5
    self.object_type=1
    self.object_id=comment.post_id

    self.save
  end

  def join(user)
    self.subject_type=1
    self.subject_id=user.id
    self.action_type=6
    self.save

  end


  def publish_article(article)
    self.subject_type=2
    self.subject_id=article.catcher.author_id
    self.action_type=7
    self.object_type=2
    self.object_id=article.id

    self.save
  end

end
