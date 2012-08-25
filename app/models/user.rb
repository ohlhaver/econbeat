class User < ActiveRecord::Base
  attr_accessible :email, :password, :name, :password_confirmation, :invitation_token
  has_secure_password
  has_many :posts
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :utopics
  has_many :filters
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation

  validates :name, presence: true, length: { maximum: 50 },
                    uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  validates_presence_of :invitation_id, :message => 'is required'
  validates_uniqueness_of :invitation_id

  before_save { |user| user.email = email.downcase }
  before_save { |user| user.name = name.downcase }


  before_create { generate_token(:auth_token) }
  before_create :set_invitation_limit

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
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

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
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

  private

    def set_invitation_limit
      self.invitation_limit = 10
    end


end
