class Relationship < ActiveRecord::Base
  belongs_to :leader, class_name: "User"
  belongs_to :follower, class_name: "User"
  
  validates :follower, uniqueness: { scope: :leader }
end