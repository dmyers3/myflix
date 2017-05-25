class User < ActiveRecord::Base
  validates_presence_of :email, :full_name
  validates :email, uniqueness: true
  
  has_secure_password
end