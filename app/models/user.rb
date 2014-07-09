class User < ActiveRecord::Base

require 'digest/md5'
require 'net/smtp'
require 'mail'
require 'net/imap'
require 'gmail'
require "rubygems"
require "google_drive"

  attr_accessible :firstname, :lastname, :password, :password_confirmation, :username

   before_save :encrypt_password

  validates :firstname,
  			:presence => true
  			
  validates :lastname,
  			:presence => true
  validates :username,
  			:presence => true,
  			:uniqueness =>true
  validates :password,
  			:presence => true,
			:confirmation =>true
  validates :password_confirmation,
  			:presence => true


def encrypt_password
	self.password = Digest::MD5.hexdigest(password)
end

def self.validate_login(username, password)

	user = User.find_by_username(username)

	if user && user.password == Digest::MD5.hexdigest(password)
		user
	else
		nil
	end
end  


end
