class VideosController < ApplicationController
  before_action :redirect_logged_out
  
  def index
    @categories = Category.all
  end
  
  def show
    @video = Video.find(params[:id])
  end
  
  def search
    @videos = Video.search_by_title(params[:query])
  end
end