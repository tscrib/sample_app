# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#
require 'will_paginate/array'

class User < ActiveRecord::Base
	attr_accessible :email, :name, :password, :password_confirmation
	has_secure_password

	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
 	has_many :followers, through: :reverse_relationships, source: :follower

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


	# Public Function Definitions
	def feed
	    Micropost.from_users_followed_by(self)
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

	# Use case insensitive search when querying names
	def self.search(search, page)
		if search
			@users=find(:all, conditions: ['name ILIKE ?', "%#{search}%"]).paginate(page: page)
		else
			@users=User.paginate(page: page)
		end
		
	end


	# Private Function Definitions
	private

		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
