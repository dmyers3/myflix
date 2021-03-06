class Admin::VideosController < AdminsController
  
  def new
    @video = Video.new
  end
  
  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "Video added!"
      redirect_to new_admin_video_path
    else
      flash[:danger] = "Error adding video."
      render 'new'
    end
  end
  
  private
  
  def video_params
    params.require(:video).permit(:title, :category, :description, :large_cover, :small_cover, :category_id, :video_url)
  end
end