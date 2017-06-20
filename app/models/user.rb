class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_positions, -> { order('position ASC') }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  has_many :followers, through: :leading_relationships
  has_many :leaders, through: :following_relationships
  
  
  validates_presence_of :email, :full_name
  validates :email, uniqueness: true
  
  has_secure_password
  
  def follows?(leader)
    !!Relationship.find_by(follower_id: id, leader_id: leader.id)
  end
end