class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_positions, -> { order('position ASC') }
  
  validates_presence_of :email, :full_name
  validates :email, uniqueness: true
  
  has_secure_password
end