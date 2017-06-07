class QueuePositionsController < ApplicationController
  before_action :redirect_logged_out
  
  def index
    @user_queue = current_user.queue_positions
  end
  
  def create
    video = Video.find(params[:video_id])
    @queue_position = QueuePosition.new(position: QueuePosition.new_position(current_user),
    video: video, user: current_user)
    
    if @queue_position.save
      redirect_to my_queue_path
    else
      flash[:danger] = "You can't do that."
      redirect_to :back
    end
  end
  
  def update_queue
    begin
      update_queue_items
      QueuePosition.reorder(current_user)
    rescue ActiveRecord::RecordInvalid  
      flash[:danger] = "Invalid position numbers."
    end
    redirect_to my_queue_path
  end
  
  def destroy
    queue_position = QueuePosition.find(params[:id])
    if queue_position.user == current_user
      queue_position.destroy
      QueuePosition.reorder(current_user)
    end
    redirect_to my_queue_path
  end
  
  private
  
  def update_queue_items
    ActiveRecord::Base.transaction do
      params['queue_positions'].each do |queue_position_data|
        queue_item = QueuePosition.find(queue_position_data['id'])
        queue_item.update_attributes!(position: queue_position_data['position'], stars: queue_position_data['stars']) if queue_item.user == current_user
        
      end
    end
  end
end