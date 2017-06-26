class QueuePosition < ActiveRecord::Base
  default_scope { order(position: :asc) }
  
  belongs_to :user
  belongs_to :video
  
  validates :position, presence: true, numericality: { only_integer: true }
  validates :video, uniqueness: { scope: :user } 
  
  def video_title
    video.title
  end
  
  def category_name
    video.category.name
  end
  
  def category
    video.category
  end
  
  def stars
    review ? review.stars : nil
  end
  
  def stars=(new_stars)
    
    if review
      review.update_column(:stars, new_stars)
    else
      review = Review.new(stars: new_stars, user: user, video: video)
      review.save(validate: false)
    end
  end
  
  def self.new_position(user)
    user.queue_positions.count + 1
  end
  
  def self.reorder(user)
    user.queue_positions.each_with_index do |queue_position, index|
      queue_position.position = index + 1
      queue_position.save
    end
  end
  
  private
  
  def review
    @review ||= Review.find_by(user_id: user.id, video_id: video.id)
  end
end