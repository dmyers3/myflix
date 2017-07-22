class VideosController < AuthenticatedController
  
  def index
    @categories = Category.all
  end
  
  def show
    @video = VideoDecorator.decorate(Video.find(params[:id]))
    @reviews = @video.reviews
    @review = Review.new
  end
  
  def search
    @videos = Video.search_by_title(params[:query])
  end
  
  def advanced_search
    options = {}
    options[:reviews] = true if params[:reviews] = 1
    options[:rating_from] = params[:rating_from] if params[:rating_from] != '-'
    options[:rating_to] = params[:rating_to] if params[:rating_to] != '-'
    if params[:query]
      @videos = Video.search(params[:query], options).records.to_a
    else
      @videos = []
    end
  end
end