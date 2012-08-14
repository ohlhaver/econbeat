class User < ActiveRecord::Base
  attr_accessible :email, :password, :name, :password_confirmation
  has_secure_password
  validates_uniqueness_of :email, :name
end
