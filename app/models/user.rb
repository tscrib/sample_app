# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
	attr_accessible :email, :name, :password, :password_confirmation
	has_secure_password

	before_save { self.email.downcase! }
	before_save :create_remember_token
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name, presence: true, length: {maximum: 50 }
	validates :email, presence: true, 
			format: { with: VALID_EMAIL_REGEX }, 
			uniqueness: { case_sensitive: false}
	# Removed "presence: true" validator. This is a hack 
	#   to make the error output more readable.
	#   See config/locales/en.yml for the hack
	validates :password, length: { minimum: 6 }
	validates :password_confirmation, presence: true

	# Private Function Definitions
	private

		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
