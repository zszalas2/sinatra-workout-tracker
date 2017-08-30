class User < ActiveRecord::Base
	has_secure_password
	validates_presence_of :username, :password_digest
	has_many :workouts
end