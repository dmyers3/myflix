class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  index_name ["myflix", Rails.env].join('_')
  
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_positions
  
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  
  validates :title, presence: true
  validates :description, presence: true
  
  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title ILIKE ?", "%#{search_term}%").order("created_at DESC")
  end
  
  def self.most_recent
    order("created_at DESC").limit(6)
  end
  
  def self.search(query, options={})
    search_definition = {
      query: {
        bool: {
          must: {
            multi_match: {
              query: query,
              fields: ["title^100", "description^50"],
              operator: "and"
            }
          }
        }
      }
    }
    
    if options[:reviews].present?
      search_definition[:query][:bool][:must][:multi_match][:fields] << "reviews.content"
    end
    
    if options[:rating_from].present? || options[:rating_to].present?
      lower_bound = options[:rating_from] || 0
      upper_bound = options[:rating_to] || 5
      
      search_definition[:query][:bool][:must][:filter] = { 
        range: { 
          average_rating: { 
            gte: lower_bound, lte: upper_bound
          }
        }
      }
    end
    __elasticsearch__.search(search_definition)
  end
  
  def average_rating
    '%.1f' % (total_stars / self.reviews.size) if total_stars
  end
  
  # def as_json(options={})
  #   super(only: [:title])
  # end
  
  # elasticsearch method
  def as_indexed_json(options={})
    as_json(only: [:title, :description], methods: [:average_rating],
    include: { reviews: { root: true, only: [:content] }})
  end
  
  private
    def total_stars
      self.reviews.map do |review|
        review.stars.to_f
      end.reduce(&:+)
    end
end