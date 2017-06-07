class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_positions
  
  validates :title, presence: true
  validates :description, presence: true
  
  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title ILIKE ?", "%#{search_term}%").order("created_at DESC")
  end
  
  def self.most_recent
    order("created_at DESC").limit(6)
  end
  
  def average_rating
    '%.1f' % (total_stars / self.reviews.size) if total_stars
  end
  
  private
    def total_stars
      self.reviews.map do |review|
        review.stars.to_f
      end.reduce(&:+)
    end
end