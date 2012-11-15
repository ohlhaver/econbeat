class User < ActiveRecord::Base
  attr_accessible :email, :password, :name, :password_confirmation, :invitation_token
  #has_secure_password
  has_many :posts, :dependent => :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :utopics
  has_many :filters
  has_many :comments
  has_many :likes
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  has_many :subscriptions, :dependent => :destroy
  has_many :starred_subscriptions, 
          :class_name => "Subscription", 
          :source => :subscription,  :conditions => ['subscriptions.starred =?', true]
  has_many :authors, through: :subscriptions 
  has_many :articles, through: :authors
  has_many :actions
  belongs_to :invitation
  validates_uniqueness_of :uid
  after_create :follow_fb_friends
  after_create :join_action
  

  #validates :name, presence: true, length: { maximum: 50 },
  #                  uniqueness: { case_sensitive: false }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  #                  uniqueness: { case_sensitive: false }
  #validates :password, length: { minimum: 6 }
  #validates :password_confirmation, presence: true

  #validates_presence_of :invitation_id, :message => 'is required'
  #validates_uniqueness_of :invitation_id

  #before_save { |user| user.email = email.downcase }
  #before_save { |user| user.name = name.downcase }


  #before_create { generate_token(:auth_token) }
  #before_create :set_invitation_limit


  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      #user = User.find_or_create_by_uid(auth.uid)
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.picture = user.facebook.get_picture("me")
      user.save!
    end
  end


  def sync_fb
    @fb_posts = self.facebook.fql_query("SELECT title,summary,url,created_time,link_id,picture FROM link WHERE owner=me()")
    @fb_posts.each do |fb_post|

      @post = Post.new
      @post.user = self
      @post.url = fb_post["url"][0,250]
      @post.fbid = fb_post["link_id"]
      @post.fbaction_id = fb_post["link_id"] 
      @post.headline = fb_post["title"][0,250] if fb_post["title"] != nil
      @post.description = fb_post["summary"][0,250] if fb_post["summary"] != nil
      @post.topic_id = 0
      @post.picture = fb_post["picture"]
      @post.created_at = Time.at(fb_post["created_time"])
      @post.save
   
    end
  end




  def load_friends_posts
    @friends = self.facebook.get_connections("me", "friends").first(5)
    @friends.each do |friend|
      @user=User.new
      #@user=User.find_or_create_by_uid(friend["id"])
      @user.uid = friend["id"]
      @user.name = friend["name"]
      @user.picture = self.facebook.get_picture(friend["id"])
      

      if @user.save
        @fb_posts = self.facebook.get_connections(@user.uid,"links")
        @fb_posts.each do |fb_post|

            @post = Post.new
            @post.user = @user
            @post.url = fb_post["link"]
            @post.fbid = fb_post["id"]
            @post.headline = fb_post["name"]
            @post.description = fb_post["description"]
            @post.topic_id = 0
            @post.picture = fb_post["picture"]
            @post.created_at = Time.at(fb_post["created_time"].to_time)
            @post.save
        end
        self.follow!(@user)        
      end
    end
  end

  def reload_authors
    self.posts.where(:author => nil).each do |post|
      begin
      @doc = Pismo::Document.new(post.url) 
      rescue => ex
        post.author = ""
        next
      end 
        if @doc.author != nil
          post.author = @doc.author[0,250]
        else
          post.author = ""
        end
        post.save
      end
  end

  def fb_subscribe(author_url)
    if Rails.env.development?  
      self.facebook.put_connections("me", "og:follows", profile: author_url)
    else
      self.facebook.put_connections("me", "og:follows", profile: author_url)
    end

  end

  def fb_subscribe_raw(author, author_url)
    self.facebook.put_wall_post("follows all articles by " + author.name + " using Jurnalo", :link => author_url)
  end

  def fb_star_raw(author, author_url)
    self.facebook.put_wall_post("starred " + author.name + " on Jurnalo", :link => author_url)
  end

  def fb_unsubscribe(author_url)
    if Rails.env.development?  
     a=self.facebook.get_connections("me","og:follows")
    else
      a=self.facebook.get_connections("me","og:follows")
    end
    s=a.select {|f| f["data"]["profile"]["url"] == author_url}
    self.facebook.delete_object(s.first["id"])
  end

  def fbstar_author(author_url)
    if Rails.env.development?  
      self.facebook.put_connections("me", "jurnalo_local:star", profile: author_url)
    else
      self.facebook.put_connections("me", "jurnalo:star", profile: author_url)
    end
  end

  def fbunstar_author(author_url)
    if Rails.env.development?  
     a=self.facebook.get_connections("me","jurnalo_local:star")
    else
      a=self.facebook.get_connections("me","jurnalo:star")
    end
    s=a.select {|f| f["data"]["author"]["url"] == author_url}
    self.facebook.delete_object(s.first["id"])
  end

  def fbstar(post_url)
    if Rails.env.development?  
      self.facebook.put_connections("me", "jurnalo_local:star", article: post_url)
    else
      self.facebook.put_connections("me", "jurnalo:star", article: post_url)
    end
  end

  def fbunstar(post_url)
    if Rails.env.development?  
     a=self.facebook.get_connections("me","jurnalo_local:star")
    else
      a=self.facebook.get_connections("me","jurnalo:star")
    end
    s=a.select {|f| f["data"]["article"]["url"] == post_url}
    self.facebook.delete_object(s.first["id"])
  end


  def fblike(post_url, post)
          a=self.facebook.get_connections("me","og.likes")
          s=a.select {|f| f["data"]["object"]["url"] == post_url}
          unless s.empty?
           self.facebook.delete_object(s.first["id"])
          end
          self.facebook.put_connections("me", "og.likes", object: post_url)
          post.likes_count = self.facebook.get_object(post_url)["shares"]
          post.save
  end

  def fb_article_like(article_url, article)
          a=self.facebook.get_connections("me","og.likes")
          s=a.select {|f| f["data"]["object"]["url"] == article_url}
          unless s.empty?
           self.facebook.delete_object(s.first["id"])
          end
          self.facebook.put_connections("me", "og.likes", object: article_url)
          #post.likes_count = self.facebook.get_object(post_url)["shares"]
          #post.save
  end

    def fb_author_like(author_url, author)
          a=self.facebook.get_connections("me","og.likes")
          s=a.select {|f| f["data"]["object"]["url"] == author_url}
          unless s.empty?
           self.facebook.delete_object(s.first["id"])
          end
          self.facebook.put_connections("me", "og.likes", object: author_url)
          #post.likes_count = self.facebook.get_object(post_url)["shares"]
          #post.save
  end




  def fbpost(post_url, post)
    if Rails.env.development? 
      p=self.facebook.put_connections("me", "jurnalo_local:share", article: post_url)
    else
      p=self.facebook.put_connections("me", "jurnalo:share", article: post_url)
    end
    post.fbaction_id = p["id"]
    post.save
  end



  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil # or consider a custom null object
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(:validate => false)
    UserMailer.delay.password_reset(self)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def feed
    a = Post.from_users_followed_by(self)
    
    self.filters.each do |f|
      a = a - f.utopic.posts if f.utopic != nil
    end
    return a
  end

  def user_action_feed
       a = Action.latest_from_users_followed_by(self)
    return a

  end


  def friends_action_feed
       a = Action.latest_from_other_users_followed_by(self)
    return a

  end

   def author_action_feed
       a = Action.latest_from_authors_followed_by(self)
    return a

  end

  def starred_author_action_feed
       a = Action.latest_from_authors_starred_by(self)
    return a

  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def follow_back(other_user)
    r=Relationship.new
    r.follower_id = other_user.id
    r.followed_id = self.id
    r.save
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

  def subscribed?(author)
    subscriptions.find_by_author_id(author.id)
  end

  def subscribe!(author)
    subscription = subscriptions.create!(author_id: author.id)
    subscribe_action(subscription) if subscription.save
  end

  def unsubscribe!(author)
    subscriptions.find_by_author_id(author.id).destroy
    a=Action.find_by_user_id_and_author_obj_id(self, author.id)
    a.hide
  end

  def post_action(post)
     a=Action.new 
      a.new_post(post)
  end

  def like_post_action(like)
     a=Action.new 
      a.like_post(like)
  end

  def like_article_action(like)
     a=Action.new 
      a.like_article(like)
  end

    def like_author_action(author)
     a=Action.new 
      a.like_author(author, self)
  end

  def subscribe_action(subscription)
     a=Action.new 
      a.subscribe_author(subscription)
  end

  def star_author_action(subscription)
     a=Action.new 
      a.star_author(subscription)
  end

  def join_action
    a=Action.new
    a.join(self)
  end

  def comment_action(comment)
    a=Action.new
    a.comment_on_action(comment)
  end

  def recommended

      @friends = self.followed_users

      @all_authors =[]

      @friends.each do |u|
        @all_authors += u.authors
      end
      @all_authors = @all_authors.uniq

    @all_authors -= self.authors if self.authors 
    @friends_authors = @all_authors.sort! { |a,b| b.users.count <=> a.users.count }.first(25)

    if @friends_authors.empty?

      list_of_ids = List.last.top_authors.split(",").first(25)

      @authors = []
      list_of_ids.each do |i|
        @authors += Array.wrap(Author.find(i))
      end
      @authors -= self.authors if self.authors 
    end

    return @friends_authors, @authors
  end



  private

    def set_invitation_limit
      self.invitation_limit = 10
    end

  #def follow_fb_friends
  #  follow_fb_friends_loop.delay
  #end

    def follow_fb_friends
      follow_fb_friends_action.delay
    end

    def follow_fb_friends_action
      @friends = self.facebook.get_connections("me", "friends")
      @friends.each do |friend|
        jurnalo_user = User.find_by_uid(friend["id"])
        if jurnalo_user
          self.follow!(jurnalo_user)
          follow_back(jurnalo_user)
        end
      end
    end


end
