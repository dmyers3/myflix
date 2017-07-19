require_relative '../../lib/tokenable'
require "#{Rails.root}/lib/tokenable.rb"

# can do config.autoload_paths << "#{Rails.root}/lib" in config/application.rb to include modules

class User < ActiveRecord::Base
  include Tokenable
  
  has_many :reviews
  has_many :queue_positions, -> { order('position ASC') }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  has_many :followers, through: :leading_relationships
  has_many :leaders, through: :following_relationships
  has_many :invitations
  has_many :payments
  
  
  validates_presence_of :email, :full_name
  validates :email, uniqueness: true
  validates :token, uniqueness: true, allow_nil: true
  
  has_secure_password
  
  def follows?(leader)
    !!Relationship.find_by(follower_id: id, leader_id: leader.id)
  end
  
  def no_hold?
    hold == nil || hold == false
  end
  
  def admin?
    self.admin
  end
end