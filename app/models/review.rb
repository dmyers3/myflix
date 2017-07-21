class Review < ActiveRecord::Base
  default_scope { order(created_at: :desc) }
  
  belongs_to :video, touch: true
  belongs_to :user
  
  validates :stars, presence: true
  validates :video_id, uniqueness: { scope: :user_id, message: "can only have one review per person." }
end