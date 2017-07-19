class Payment < ActiveRecord::Base
  belongs_to :user
  
  private
  
  def self.recent
    order("created_at DESC").limit(8)
  end
end