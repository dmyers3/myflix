class RelationshipsController < ApplicationController
  before_action :redirect_logged_out
  
  def index
    @relationships = current_user.following_relationships
  end
  
  def create
    follower = current_user
    leader = User.find(params[:leader_id])
    relationship = Relationship.new(follower: follower, leader: leader) if leader != follower
    
    if relationship.try(:save)
      flash[:success] = "You are now following this user."
      redirect_to people_path
    else
      flash[:danger] = "You can't do that."
      redirect_to user_path(leader)
    end
  end
  
  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end
end