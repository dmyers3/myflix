class Video < ActiveRecord::Base
  belongs_to :category
  
  validates :title, presence: true
  validates :description, presence: true
  
  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title ILIKE ?", "%#{search_term}%").order("created_at DESC")
  end
  
  def self.most_recent
    order("created_at DESC").limit(6)
  end
end