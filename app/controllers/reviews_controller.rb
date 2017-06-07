class ReviewsController < ApplicationController
  before_action :redirect_logged_out
  
  def create
    @video = Video.find(params[:video_id])
    @review = Review.new(review_params)
    @review.video = @video
    @review.user = User.find(session[:user_id])
    
    if @review.save
      redirect_to @video
    else
      flash[:danger] = "#{@review.errors.full_messages.first}"
      redirect_to @video
    end
  end
  
  private
    
    def review_params
      params.require('review').permit('stars', 'content')
    end
end