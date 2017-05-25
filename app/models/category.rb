class Category < ActiveRecord::Base
  has_many :videos, -> {order "title"}
  
  def most_recent
    videos.reorder("created_at DESC").limit(6)
  end
end