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
    if params[:query]
      @videos = Video.search(params[:query]).records.to_a
    else
      @videos = []
    end
  end
end