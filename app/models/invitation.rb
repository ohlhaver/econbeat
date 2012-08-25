class Invitation < ActiveRecord::Base
  attr_accessible :recipient_email
  belongs_to :sender, :class_name => 'User'
  has_one :recipient, :class_name => 'User'


	validates_presence_of :recipient_email
	validate :recipient_is_not_registered
	validate :sender_has_invitations, :if => :sender

	before_create :generate_invite_token
	before_create :decrement_sender_count, :if => :sender

	private

	def recipient_is_not_registered
	  errors.add :recipient_email, 'is already registered' if User.find_by_email(recipient_email)
	end

	def sender_has_invitations
	  unless sender.invitation_limit > 0
	    errors.add 'You have reached your limit of invitations to send.'
	  end
	end

	def generate_invite_token
	  self.token = SecureRandom.urlsafe_base64
	end

	def decrement_sender_count
	  sender.decrement! :invitation_limit
	end
end
